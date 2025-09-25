import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuel_pro_360/features/dashboard/data/models/chart_data_point_model.dart';
import 'package:fuel_pro_360/features/dashboard/data/models/fuel_volume_model.dart';
import 'package:fuel_pro_360/features/dashboard/data/models/dashboard_metrics_model.dart';
import 'package:fuel_pro_360/features/dashboard/data/utils/dashboard_utils.dart';

class DashboardDataSource {
  final SupabaseClient _supabaseClient;
  final String? Function() _getFuelPumpId;

  DashboardDataSource(this._supabaseClient, this._getFuelPumpId);

  /// Get sales data for bar chart (shift-based)
  Future<List<ChartDataPointModel>> getSalesData(DateTime startDate, DateTime endDate) async {
    try {
      // Get the current fuel pump ID
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        print('getSalesData: No fuel pump selected, returning mock data for development');
        return _generateMockSalesData();
      }
      
      print('getSalesData: Using selected fuel pump ID: $fuelPumpId');
      
      print('getSalesData: Fetching shift-based sales for fuel pump $fuelPumpId');
      
      // Fetch completed shifts and their readings for the date range
      final response = await _supabaseClient
          .from('shifts')
          .select('''
            id,
            end_time,
            readings (
              cash_sales,
              card_sales,
              upi_sales,
              others_sales,
              indent_sales,
              consumable_expenses
            )
          ''')
          .eq('fuel_pump_id', fuelPumpId)
          .eq('status', 'completed')
          .gte('end_time', '${DashboardUtils.formatDate(startDate)} 00:00:00')
          .lte('end_time', '${DashboardUtils.formatDate(endDate)} 23:59:59')
          .order('end_time', ascending: true);
      
      final shiftsData = response as List<dynamic>?;
      
      if (shiftsData == null || shiftsData.isEmpty) {
        print('getSalesData: No completed shifts found for fuel pump $fuelPumpId');
        return [];
      }
      
      print('getSalesData: Found ${shiftsData.length} completed shifts for fuel pump $fuelPumpId');
      
      // Group data by date
      final Map<String, double> groupedByDate = {};
      
      for (final shift in shiftsData) {
        final endTime = shift['end_time'] as String?;
        final readings = shift['readings'] as List<dynamic>?;
        
        if (endTime == null || readings == null) continue;
        
        final dateStr = endTime.split('T')[0];
        final formattedDate = DashboardUtils.formatDateRange(DateTime.parse(dateStr));
        
        groupedByDate[formattedDate] ??= 0;
        
        // Calculate total FUEL sales from the first reading of each shift (excluding consumables)
        if (readings.isNotEmpty) {
          final firstReading = readings[0] as Map<String, dynamic>;
          final fuelSalesOnly = (firstReading['cash_sales'] as num? ?? 0) +
                               (firstReading['card_sales'] as num? ?? 0) +
                               (firstReading['upi_sales'] as num? ?? 0) +
                               (firstReading['others_sales'] as num? ?? 0) +
                               (firstReading['indent_sales'] as num? ?? 0);
          // Note: consumable_expenses excluded from fuel sales to avoid inflation
          
          groupedByDate[formattedDate] = groupedByDate[formattedDate]! + fuelSalesOnly.toDouble();
        }
      }
      
      // Convert to chart data format
      return groupedByDate.entries.map((entry) => ChartDataPointModel(
        name: entry.key,
        total: entry.value.round().toDouble(),
      )).toList();
      
    } catch (error) {
      print('Error fetching shift-based sales data: $error');
      return [];
    }
  }

  /// Get fuel volume data using stored daily_readings data
  Future<List<FuelVolumeModel>> getFuelVolumeData(DateTime startDate, DateTime endDate) async {
    try {
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        print('getFuelVolumeData: No fuel pump ID available, returning mock data for development');
        return _generateMockFuelVolumeData();
      }
      
      print('getFuelVolumeData: Fetching daily_readings data for fuel pump $fuelPumpId');
      
      // Get actual meter sales from daily_readings table
      final response = await _supabaseClient
          .from('daily_readings')
          .select('date, fuel_type, actual_meter_sales')
          .eq('fuel_pump_id', fuelPumpId)
          .gte('date', DashboardUtils.formatDate(startDate))
          .lte('date', DashboardUtils.formatDate(endDate))
          .order('date', ascending: true);
      
      final dailyReadings = response as List<dynamic>?;
      
      if (dailyReadings == null || dailyReadings.isEmpty) {
        print('getFuelVolumeData: No daily readings found for fuel pump $fuelPumpId');
        return [];
      }
      
      print('getFuelVolumeData: Found ${dailyReadings.length} daily readings for fuel pump $fuelPumpId');
      
      // Group data by date and fuel type
      final Map<String, Map<String, double>> groupedByDate = {};
      
      for (final reading in dailyReadings) {
        final dateStr = reading['date'] as String;
        final formattedDate = DashboardUtils.formatDateRange(DateTime.parse(dateStr));
        final fuelType = reading['fuel_type'] as String;
        final volume = (reading['actual_meter_sales'] as num? ?? 0).toDouble();
        
        groupedByDate[formattedDate] ??= {};
        groupedByDate[formattedDate]![fuelType] ??= 0;
        groupedByDate[formattedDate]![fuelType] = 
            groupedByDate[formattedDate]![fuelType]! + volume;
      }
      
      // Convert to chart data format with dynamic fuel types
      final chartData = groupedByDate.entries.map((entry) {
        final dayData = <String, double>{};
        
        // Add all fuel types for this date
        entry.value.forEach((fuelType, volume) {
          dayData[fuelType.toLowerCase()] = volume.round().toDouble();
        });
        
        return FuelVolumeModel(
          name: entry.key,
          fuelTypes: dayData,
        );
      }).toList();
      
      print('getFuelVolumeData: Generated chart data: $chartData');
      return chartData;
    } catch (error) {
      print('Error fetching fuel volume data: $error');
      return [];
    }
  }

  /// Get recent transactions
  Future<List<Map<String, dynamic>>> getRecentTransactions({int limit = 3}) async {
    try {
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        print('getRecentTransactions: No fuel pump ID available, returning mock data for development');
        return _generateMockRecentTransactions();
      }
      
      print('getRecentTransactions: Fetching for fuel pump $fuelPumpId');
      
      final response = await _supabaseClient
          .from('transactions')
          .select('id, fuel_type, amount, created_at, quantity')
          .eq('fuel_pump_id', fuelPumpId)
          .order('created_at', ascending: false)
          .limit(limit);
      
      final data = response as List<dynamic>?;
      
      if (data == null) {
        print('getRecentTransactions: No transactions found for fuel pump $fuelPumpId');
        return [];
      }
      
      print('getRecentTransactions: Found ${data.length} transactions for fuel pump $fuelPumpId');
      return data.cast<Map<String, dynamic>>();
    } catch (error) {
      print('Error fetching recent transactions: $error');
      return [];
    }
  }

  /// Get current fuel levels
  Future<Map<String, double>> getCurrentFuelLevels() async {
    try {
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        print('getCurrentFuelLevels: No fuel pump ID available, returning mock data for development');
        return _generateMockFuelLevels();
      }
      
      print('getCurrentFuelLevels: Fetching for fuel pump $fuelPumpId');
      
      final response = await _supabaseClient
          .from('fuel_settings')
          .select('fuel_type, current_level, tank_capacity')
          .eq('fuel_pump_id', fuelPumpId);
      
      final data = response as List<dynamic>?;
      final Map<String, double> fuelLevels = {};
      
      if (data != null && data.isNotEmpty) {
        print('getCurrentFuelLevels: Found ${data.length} fuel types for fuel pump $fuelPumpId');
        
        for (final fuel in data) {
          final currentLevel = fuel['current_level'] as num?;
          final tankCapacity = fuel['tank_capacity'] as num?;
          final fuelType = fuel['fuel_type'] as String;
          
          if (currentLevel != null && tankCapacity != null && tankCapacity > 0) {
            final percentage = (currentLevel / tankCapacity) * 100;
            fuelLevels[fuelType] = (percentage > 100 ? 100 : percentage).roundToDouble();
          } else {
            fuelLevels[fuelType] = 0;
          }
        }
      } else {
        print('getCurrentFuelLevels: No fuel settings found for fuel pump $fuelPumpId');
      }
      
      return fuelLevels;
    } catch (error) {
      print('Error fetching fuel levels: $error');
      return {};
    }
  }

  /// Get configured fuel types for current fuel pump
  Future<List<String>> getConfiguredFuelTypes() async {
    try {
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        print('getConfiguredFuelTypes: No fuel pump ID available');
        return [];
      }

      final response = await _supabaseClient
          .from('fuel_settings')
          .select('fuel_type')
          .eq('fuel_pump_id', fuelPumpId)
          .order('fuel_type');

      final data = response as List<dynamic>?;
      return data?.map((item) => item['fuel_type'] as String).toList() ?? [];
    } catch (error) {
      print('Error fetching configured fuel types: $error');
      return [];
    }
  }

  /// Get dashboard metrics (shift-based)
  Future<DashboardMetricsModel> getDashboardMetrics(DateTime startDate, DateTime endDate) async {
    try {
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        print('getDashboardMetrics: No fuel pump ID available, returning mock data for development');
        return _generateMockMetrics();
      }
      
      print('getDashboardMetrics: Fetching shift-based metrics for fuel pump $fuelPumpId');
      
      // Get total sales from completed shifts
      final shiftsResponse = await _supabaseClient
          .from('shifts')
          .select('''
            readings (
              fuel_type,
              opening_reading,
              closing_reading,
              testing_fuel,
              card_sales,
              upi_sales,
              cash_sales,
              others_sales,
              indent_sales,
              shift_id
            )
          ''')
          .eq('fuel_pump_id', fuelPumpId)
          .eq('status', 'completed')
          .gte('end_time', '${DashboardUtils.formatDate(startDate)} 00:00:00')
          .lte('end_time', '${DashboardUtils.formatDate(endDate)} 23:59:59');
      
      // Get customer count
      final customerResponse = await _supabaseClient
          .from('customers')
          .select('id')
          .eq('fuel_pump_id', fuelPumpId);
      
      final shiftsData = shiftsResponse as List<dynamic>?;
      final customerData = customerResponse as List<dynamic>?;
      
      // Calculate total sales and fuel volume from shifts
      double totalSales = 0;
      double totalFuelVolume = 0;
      
      if (shiftsData != null) {
        for (final shift in shiftsData) {
          final readings = shift['readings'] as List<dynamic>?;
          if (readings != null && readings.isNotEmpty) {
            // Use first reading to avoid double counting - FUEL sales only
            final firstReading = readings[0] as Map<String, dynamic>;
            totalSales += (firstReading['cash_sales'] as num? ?? 0) +
                         (firstReading['card_sales'] as num? ?? 0) +
                         (firstReading['upi_sales'] as num? ?? 0) +
                         (firstReading['others_sales'] as num? ?? 0) +
                         (firstReading['indent_sales'] as num? ?? 0);
            // Note: consumable_expenses excluded from fuel sales metrics
            
            // Calculate fuel volume from all readings in the shift, subtracting testing fuel
            for (final reading in readings) {
              final readingMap = reading as Map<String, dynamic>;
              final closingReading = readingMap['closing_reading'] as num?;
              final openingReading = readingMap['opening_reading'] as num?;
              
              if (closingReading != null && openingReading != null) {
                final volumeDispensed = (closingReading - openingReading).toDouble();
                final testingFuel = (readingMap['testing_fuel'] as num? ?? 0).toDouble();
                totalFuelVolume += (volumeDispensed - testingFuel).clamp(0.0, double.infinity);
              }
            }
          }
        }
      }
      
      // Get previous period data for growth calculation
      final previousPeriodStart = DashboardUtils.getPreviousPeriodStart(startDate, endDate);
      final previousPeriodEnd = DashboardUtils.getPreviousPeriodEnd(startDate, endDate);
      
      final prevShiftsResponse = await _supabaseClient
          .from('shifts')
          .select('''
            readings (
              cash_sales,
              card_sales,
              upi_sales,
              others_sales,
              indent_sales,
              consumable_expenses
            )
          ''')
          .eq('fuel_pump_id', fuelPumpId)
          .eq('status', 'completed')
          .gte('end_time', '${DashboardUtils.formatDate(previousPeriodStart)} 00:00:00')
          .lte('end_time', '${DashboardUtils.formatDate(previousPeriodEnd)} 23:59:59');
      
      final prevShiftsData = prevShiftsResponse as List<dynamic>?;
      
      // Calculate previous period sales from shifts
      double prevTotalSales = 0;
      if (prevShiftsData != null) {
        for (final shift in prevShiftsData) {
          final readings = shift['readings'] as List<dynamic>?;
          if (readings != null && readings.isNotEmpty) {
            final firstReading = readings[0] as Map<String, dynamic>;
            prevTotalSales += (firstReading['cash_sales'] as num? ?? 0) +
                             (firstReading['card_sales'] as num? ?? 0) +
                             (firstReading['upi_sales'] as num? ?? 0) +
                             (firstReading['others_sales'] as num? ?? 0) +
                             (firstReading['indent_sales'] as num? ?? 0);
            // Note: consumable_expenses excluded from fuel sales growth calculation
          }
        }
      }
      
      // Calculate growth percentage
      final growthPercentage = DashboardUtils.calculateGrowthPercentage(totalSales, prevTotalSales);
      
      print('getDashboardMetrics: Metrics for fuel pump $fuelPumpId: totalSales=$totalSales, customerCount=${customerData?.length ?? 0}, fuelVolume=$totalFuelVolume, growth=$growthPercentage');
      
      return DashboardMetricsModel(
        totalSales: DashboardUtils.formatCurrency(totalSales),
        customers: (customerData?.length ?? 0).toString(),
        fuelVolume: DashboardUtils.formatVolume(totalFuelVolume),
        growth: DashboardUtils.formatGrowthPercentage(growthPercentage),
      );
    } catch (error) {
      print('Error fetching dashboard metrics: $error');
      return const DashboardMetricsModel(
        totalSales: '₹0',
        customers: '0',
        fuelVolume: '0 L',
        growth: '0%',
      );
    }
  }

  /// Get transaction summary for a date range
  Future<Map<String, dynamic>> getTransactionSummaryForDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        print('getTransactionSummaryForDateRange: No fuel pump ID available, returning mock data for development');
        return _generateMockTransactionSummary();
      }

      final formattedStartDate = DashboardUtils.formatDate(startDate);
      final formattedEndDate = DashboardUtils.formatDate(endDate);
      print('getTransactionSummaryForDateRange: Fetching for fuel pump $fuelPumpId from $formattedStartDate to $formattedEndDate');

      // Get configured fuel types
      final fuelTypes = await getConfiguredFuelTypes();

      // Get indent sales for the date range
      final indentResponse = await _supabaseClient
          .from('transactions')
          .select('amount')
          .eq('fuel_pump_id', fuelPumpId)
          .gte('date', formattedStartDate)
          .lte('date', formattedEndDate)
          .eq('payment_method', 'indent');

      // Get consumables sales for the date range
      final consumablesResponse = await _supabaseClient
          .from('transaction_consumables')
          .select('total_amount')
          .eq('fuel_pump_id', fuelPumpId)
          .gte('created_at', '$formattedStartDate 00:00:00')
          .lt('created_at', '$formattedEndDate 23:59:59');

      // Get shift-based data for fuel sales
      final shiftsResponse = await _supabaseClient
          .from('shifts')
          .select('''
            id,
            end_time,
            readings (
              fuel_type,
              opening_reading,
              closing_reading,
              testing_fuel,
              card_sales,
              upi_sales,
              cash_sales,
              others_sales,
              shift_id
            )
          ''')
          .eq('fuel_pump_id', fuelPumpId)
          .eq('status', 'completed')
          .gte('end_time', '$formattedStartDate 00:00:00')
          .lte('end_time', '$formattedEndDate 23:59:59');

      final indentData = indentResponse as List<dynamic>?;
      final consumablesData = consumablesResponse as List<dynamic>?;
      final shiftsData = shiftsResponse as List<dynamic>?;

      // Calculate indent sales
      final indentAmount = indentData?.fold<double>(0, (sum, item) => 
          sum + ((item['amount'] as num? ?? 0).toDouble())) ?? 0;
      final indentCount = indentData?.length ?? 0;

      // Calculate consumables sales
      final consumablesAmount = consumablesData?.fold<double>(0, (sum, item) => 
          sum + ((item['total_amount'] as num? ?? 0).toDouble())) ?? 0;
      final consumablesCount = consumablesData?.length ?? 0;

      // Initialize fuel type sales
      final Map<String, Map<String, dynamic>> fuelTypeSales = {};
      for (final fuelType in fuelTypes) {
        fuelTypeSales[fuelType] = {
          'volume': '0 L',
          'amount': '₹0',
          'count': 0
        };
      }

      // Process shift data for fuel sales
      if (shiftsData != null) {
        for (final shift in shiftsData) {
          final readings = shift['readings'] as List<dynamic>?;
          if (readings == null || readings.isEmpty) continue;
          
          // Group readings by fuel type for this shift
          final Map<String, List<Map<String, dynamic>>> readingsByFuelType = {};
          for (final reading in readings) {
            final readingMap = reading as Map<String, dynamic>;
            final fuelType = readingMap['fuel_type'] as String?;
            if (fuelType == null) continue;
            
            readingsByFuelType[fuelType] ??= [];
            readingsByFuelType[fuelType]!.add(readingMap);
          }
          
          // Process each fuel type in this shift
          for (final entry in readingsByFuelType.entries) {
            final fuelType = entry.key;
            final readings = entry.value;
            
            // Use FIRST reading for sales data to avoid double counting
            final firstReading = readings[0];
            final shiftSalesAmount = (firstReading['card_sales'] as num? ?? 0) + 
                                    (firstReading['upi_sales'] as num? ?? 0) + 
                                    (firstReading['cash_sales'] as num? ?? 0) + 
                                    (firstReading['others_sales'] as num? ?? 0);
            
            // Sum volumes from ALL readings for this fuel type, subtracting testing fuel
            final totalVolume = readings.fold<double>(0, (sum, reading) {
              final volumeDispensed = ((reading['closing_reading'] as num? ?? 0) - 
                                     (reading['opening_reading'] as num? ?? 0)).clamp(0.0, double.infinity);
              final testingFuel = (reading['testing_fuel'] as num? ?? 0).toDouble();
              return sum + (volumeDispensed - testingFuel).clamp(0.0, double.infinity);
            });
            
            // Match fuel type with configured types
            String? matchedFuelType = DashboardUtils.matchFuelType(fuelType, fuelTypes);
            
            // If no match, create a new bucket
            if (matchedFuelType == null) {
              matchedFuelType = fuelType;
              fuelTypeSales[matchedFuelType] = {
                'volume': '0 L',
                'amount': '₹0',
                'count': 0
              };
              print('getTransactionSummaryForDateRange: Created new fuel type bucket: $matchedFuelType');
            }
            
            // Add to totals
            final currentAmount = DashboardUtils.parseFormattedAmount(
                fuelTypeSales[matchedFuelType]!['amount'] as String);
            final currentVolume = DashboardUtils.parseFormattedVolume(
                fuelTypeSales[matchedFuelType]!['volume'] as String);
            
            fuelTypeSales[matchedFuelType] = {
              'volume': DashboardUtils.formatVolume(currentVolume + totalVolume),
              'amount': DashboardUtils.formatCurrency(currentAmount + shiftSalesAmount),
              'count': (fuelTypeSales[matchedFuelType]!['count'] as int) + 1
            };
          }
        }
      }

      // Calculate total sales
      final totalFuelAmount = fuelTypeSales.values.fold<double>(0, (sum, fuel) {
        return sum + DashboardUtils.parseFormattedAmount(fuel['amount'] as String);
      });

      final totalAmount = totalFuelAmount + consumablesAmount;
      final totalCount = consumablesCount + 
                        fuelTypeSales.values.fold<int>(0, (sum, fuel) => 
                            sum + (fuel['count'] as int));

      print('getTransactionSummaryForDateRange: Summary for fuel pump $fuelPumpId: indentAmount=$indentAmount, consumablesAmount=$consumablesAmount, totalAmount=$totalAmount');

      return {
        'indentSales': {
          'volume': '0 L', // Indent sales don't have volume, set to 0
          'amount': DashboardUtils.formatCurrency(indentAmount),
          'count': indentCount
        },
        'consumablesSales': {
          'volume': '0 L', // Consumables don't have volume, set to 0
          'amount': DashboardUtils.formatCurrency(consumablesAmount),
          'count': consumablesCount
        },
        'fuelTypeSales': fuelTypeSales,
        'total': {
          'volume': DashboardUtils.formatVolume(fuelTypeSales.values.fold<double>(0, (sum, fuel) {
            return sum + DashboardUtils.parseFormattedVolume(fuel['volume'] as String);
          })),
          'amount': DashboardUtils.formatCurrency(totalAmount),
          'count': totalCount
        }
      };
    } catch (error) {
      print('Error fetching transaction summary for date range: $error');
      return {
        'indentSales': {'volume': '0 L', 'amount': '₹0', 'count': 0},
        'consumablesSales': {'volume': '0 L', 'amount': '₹0', 'count': 0},
        'fuelTypeSales': <String, dynamic>{},
        'total': {'volume': '0 L', 'amount': '₹0', 'count': 0}
      };
    }
  }

  /// Get today's transaction summary
  Future<Map<String, dynamic>> getTodaysTransactionSummary() async {
    final today = DateTime.now();
    return getTransactionSummaryForDateRange(today, today);
  }

  /// Get today's fuel-wise sales breakdown
  Future<Map<String, Map<String, String>>> getTodaysFuelSalesBreakdown() async {
    try {
      final fuelPumpId = _getFuelPumpId();
      
      if (fuelPumpId == null) {
        return {
          'petrol': {'volume': '0 L', 'amount': '₹0'},
          'diesel': {'volume': '0 L', 'amount': '₹0'}
        };
      }

      final today = DashboardUtils.formatDate(DateTime.now());

      // Get today's fuel sales from daily_readings
      final dailyReadingsResponse = await _supabaseClient
          .from('daily_readings')
          .select('fuel_type, actual_meter_sales, testing_quantity')
          .eq('fuel_pump_id', fuelPumpId)
          .eq('date', today);

      // Get fuel prices for amount calculation
      final fuelSettingsResponse = await _supabaseClient
          .from('fuel_settings')
          .select('fuel_type, current_price')
          .eq('fuel_pump_id', fuelPumpId);

      final dailyReadings = dailyReadingsResponse as List<dynamic>?;
      final fuelSettings = fuelSettingsResponse as List<dynamic>?;

      final Map<String, double> fuelPrices = {};
      fuelSettings?.forEach((setting) {
        fuelPrices[setting['fuel_type'] as String] = 
            (setting['current_price'] as num? ?? 0).toDouble();
      });

      // Initialize totals
      final Map<String, double> petrolData = {'volume': 0, 'amount': 0};
      final Map<String, double> dieselData = {'volume': 0, 'amount': 0};

      // Process daily readings data
      dailyReadings?.forEach((reading) {
        final grossVolume = (reading['actual_meter_sales'] as num? ?? 0).toDouble();
        final testingVolume = (reading['testing_quantity'] as num? ?? 0).toDouble();
        final netVolume = (grossVolume - testingVolume).clamp(0.0, double.infinity);
        final fuelType = reading['fuel_type'] as String;
        final price = fuelPrices[fuelType] ?? 0;
        final amount = netVolume * price;
        
        if (fuelType.toLowerCase().contains('petrol')) {
          petrolData['volume'] = petrolData['volume']! + netVolume;
          petrolData['amount'] = petrolData['amount']! + amount;
        } else if (fuelType.toLowerCase().contains('diesel')) {
          dieselData['volume'] = dieselData['volume']! + netVolume;
          dieselData['amount'] = dieselData['amount']! + amount;
        }
      });

      return {
        'petrol': {
          'volume': DashboardUtils.formatVolume(petrolData['volume']!),
          'amount': DashboardUtils.formatCurrency(petrolData['amount']!)
        },
        'diesel': {
          'volume': DashboardUtils.formatVolume(dieselData['volume']!),
          'amount': DashboardUtils.formatCurrency(dieselData['amount']!)
        }
      };
    } catch (error) {
      print('Error fetching today\'s fuel sales breakdown: $error');
      return {
        'petrol': {'volume': '0 L', 'amount': '₹0'},
        'diesel': {'volume': '0 L', 'amount': '₹0'}
      };
    }
  }

  // Mock data methods for development when no fuel pump ID is available
  List<ChartDataPointModel> _generateMockSalesData() {
    return [
      const ChartDataPointModel(name: 'Mon', total: 45000),
      const ChartDataPointModel(name: 'Tue', total: 52000),
      const ChartDataPointModel(name: 'Wed', total: 38000),
      const ChartDataPointModel(name: 'Thu', total: 61000),
      const ChartDataPointModel(name: 'Fri', total: 55000),
      const ChartDataPointModel(name: 'Sat', total: 67000),
      const ChartDataPointModel(name: 'Sun', total: 43000),
    ];
  }

  List<FuelVolumeModel> _generateMockFuelVolumeData() {
    return [
      const FuelVolumeModel(name: 'Petrol', fuelTypes: {'petrol': 1250}),
      const FuelVolumeModel(name: 'Diesel', fuelTypes: {'diesel': 2100}),
    ];
  }

  DashboardMetricsModel _generateMockMetrics() {
    return const DashboardMetricsModel(
      totalSales: '₹3,45,000',
      customers: '156',
      fuelVolume: '3,350 L',
      growth: '+12.5%',
    );
  }

  Map<String, double> _generateMockFuelLevels() {
    return {
      'Petrol': 75.5,
      'Diesel': 82.3,
    };
  }

  List<Map<String, dynamic>> _generateMockRecentTransactions() {
    return [
      {
        'id': 'T001',
        'customer_name': 'John Doe',
        'amount': 2500.0,
        'fuel_type': 'Petrol',
        'volume': 25.0,
        'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'T002',
        'customer_name': 'Jane Smith',
        'amount': 3200.0,
        'fuel_type': 'Diesel',
        'volume': 30.0,
        'created_at': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      },
      {
        'id': 'T003',
        'customer_name': 'Bob Wilson',
        'amount': 1800.0,
        'fuel_type': 'Petrol',
        'volume': 18.0,
        'created_at': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      },
    ];
  }

  Map<String, dynamic> _generateMockTransactionSummary() {
    return {
      'indentSales': {'volume': '450 L', 'amount': '₹45,000', 'count': 15},
      'consumablesSales': {'volume': '0 L', 'amount': '₹5,600', 'count': 8},
      'fuelTypeSales': {
        'petrol': {'volume': '280 L', 'amount': '₹28,000', 'count': 10},
        'diesel': {'volume': '170 L', 'amount': '₹17,000', 'count': 5},
      },
      'total': {'volume': '450 L', 'amount': '₹50,600', 'count': 23},
    };
  }
}