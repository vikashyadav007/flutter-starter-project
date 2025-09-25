
import { supabase } from "@/integrations/supabase/client";
import { format, startOfMonth, endOfMonth, parseISO, isValid } from "date-fns";
import { getFuelPumpId } from "@/integrations/utils";
import { parseFormattedVolume } from "./formatUtils";

interface ChartDataPoint {
  name: string;
  total: number;
  [key: string]: any;
}

interface FuelVolume {
  name: string;
  [key: string]: any; // Support dynamic fuel types
}

interface DashboardMetrics {
  totalSales: string;
  customers: string;
  fuelVolume: string;
  growth: string;
}

interface FuelTypeSales {
  volume: string;
  amount: string;
  count: number;
}

interface TodaysTransactionSummary {
  indentSales: {
    amount: string;
    count: number;
  };
  consumablesSales: {
    amount: string;
    count: number;
  };
  fuelTypeSales: Record<string, FuelTypeSales>;
  total: {
    amount: string;
    count: number;
  };
}

// Function to get sales data for bar chart (shift-based)
export const getSalesData = async (startDate: Date, endDate: Date): Promise<ChartDataPoint[]> => {
  try {
    // Get the current fuel pump ID
    const fuelPumpId = await getFuelPumpId();
    
    if (!fuelPumpId) {
      console.log('getSalesData: No fuel pump ID available, cannot fetch sales data');
      return [];
    }
    
    console.log(`getSalesData: Fetching shift-based sales for fuel pump ${fuelPumpId}`);
    
    // Fetch completed shifts and their readings for the date range
    const { data: shiftsData, error: shiftsError } = await supabase
      .from('shifts')
      .select(`
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
      `)
      .eq('fuel_pump_id', fuelPumpId)
      .eq('status', 'completed')
      .gte('end_time', format(startDate, 'yyyy-MM-dd') + ' 00:00:00')
      .lte('end_time', format(endDate, 'yyyy-MM-dd') + ' 23:59:59')
      .order('end_time', { ascending: true });
      
    if (shiftsError) throw shiftsError;
    
    if (!shiftsData || shiftsData.length === 0) {
      console.log(`getSalesData: No completed shifts found for fuel pump ${fuelPumpId}`);
      return [];
    }
    
    console.log(`getSalesData: Found ${shiftsData.length} completed shifts for fuel pump ${fuelPumpId}`);
    
    // Group data by date
    const groupedByDate: Record<string, number> = {};
    
    shiftsData.forEach(shift => {
      if (!shift.end_time || !shift.readings) return;
      
      const dateStr = shift.end_time.split('T')[0];
      const formattedDate = format(new Date(dateStr), 'dd MMM');
      
      if (!groupedByDate[formattedDate]) {
        groupedByDate[formattedDate] = 0;
      }
      
        // Calculate total FUEL sales from the first reading of each shift (excluding consumables)
        const firstReading = shift.readings[0];
        if (firstReading) {
          const fuelSalesOnly = (Number(firstReading.cash_sales) || 0) +
                               (Number(firstReading.card_sales) || 0) +
                               (Number(firstReading.upi_sales) || 0) +
                               (Number(firstReading.others_sales) || 0) +
                               (Number(firstReading.indent_sales) || 0);
          // Note: consumable_expenses excluded from fuel sales to avoid inflation
          
          groupedByDate[formattedDate] += fuelSalesOnly;
        }
    });
    
    // Convert to chart data format
    const chartData: ChartDataPoint[] = Object.keys(groupedByDate).map(date => ({
      name: date,
      total: Math.round(groupedByDate[date])
    }));
    
    return chartData;
  } catch (error) {
    console.error('Error fetching shift-based sales data:', error);
    return [];
  }
};

// Helper function to get current user's fuel pump ID
const getCurrentUserFuelPumpId = async (): Promise<string | null> => {
  try {
    return await getFuelPumpId();
  } catch (error) {
    console.error('Error getting fuel pump ID:', error);
    return null;
  }
};

// Function to get fuel volume data using stored daily_readings data  
export const getFuelVolumeData = async (startDate: Date, endDate: Date): Promise<FuelVolume[]> => {
  try {
    const fuelPumpId = await getCurrentUserFuelPumpId();
    
    if (!fuelPumpId) {
      console.log('getFuelVolumeData: No fuel pump ID available, cannot fetch fuel data');
      return [];
    }
    
    console.log(`getFuelVolumeData: Fetching daily_readings data for fuel pump ${fuelPumpId}`);
    
    // Get actual meter sales from daily_readings table
    const { data: dailyReadings, error } = await supabase
      .from('daily_readings')
      .select('date, fuel_type, actual_meter_sales')
      .eq('fuel_pump_id', fuelPumpId)
      .gte('date', format(startDate, 'yyyy-MM-dd'))
      .lte('date', format(endDate, 'yyyy-MM-dd'))
      .order('date', { ascending: true });
      
    if (error) throw error;
    
    if (!dailyReadings || dailyReadings.length === 0) {
      console.log(`getFuelVolumeData: No daily readings found for fuel pump ${fuelPumpId}`);
      return [];
    }
    
    console.log(`getFuelVolumeData: Found ${dailyReadings.length} daily readings for fuel pump ${fuelPumpId}`);
    
    // Group data by date and fuel type
    const groupedByDate: Record<string, Record<string, number>> = {};
    
    dailyReadings.forEach(reading => {
      const dateStr = reading.date;
      const formattedDate = format(new Date(dateStr), 'dd MMM');
      const fuelType = reading.fuel_type;
      const volume = reading.actual_meter_sales || 0;
      
      if (!groupedByDate[formattedDate]) {
        groupedByDate[formattedDate] = {};
      }
      
      if (!groupedByDate[formattedDate][fuelType]) {
        groupedByDate[formattedDate][fuelType] = 0;
      }
      
      groupedByDate[formattedDate][fuelType] += volume;
    });
    
    // Convert to chart data format with dynamic fuel types
    const chartData: FuelVolume[] = Object.keys(groupedByDate).map(date => {
      const dayData: any = { name: date };
      
      // Add all fuel types for this date
      Object.entries(groupedByDate[date]).forEach(([fuelType, volume]) => {
        dayData[fuelType.toLowerCase()] = Math.round(volume);
      });
      
      return dayData;
    });
    
    console.log(`getFuelVolumeData: Generated chart data:`, chartData);
    return chartData;
  } catch (error) {
    console.error('Error fetching fuel volume data:', error);
    return [];
  }
};

// Function to get recent transactions
export const getRecentTransactions = async (limit: number = 3): Promise<any[]> => {
  try {
    // Get the current fuel pump ID
    const fuelPumpId = await getFuelPumpId();
    
    if (!fuelPumpId) {
      console.log('getRecentTransactions: No fuel pump ID available, cannot fetch transactions');
      return [];
    }
    
    console.log(`getRecentTransactions: Fetching for fuel pump ${fuelPumpId}`);
    
    const { data, error } = await supabase
      .from('transactions')
      .select('id, fuel_type, amount, created_at, quantity')
      .eq('fuel_pump_id', fuelPumpId)
      .order('created_at', { ascending: false })
      .limit(limit);
      
    if (error) throw error;
    
    if (!data) {
      console.log(`getRecentTransactions: No transactions found for fuel pump ${fuelPumpId}`);
      return [];
    }
    
    console.log(`getRecentTransactions: Found ${data.length} transactions for fuel pump ${fuelPumpId}`);
    return data;
  } catch (error) {
    console.error('Error fetching recent transactions:', error);
    return [];
  }
};

// Function to get current fuel levels
export const getCurrentFuelLevels = async (): Promise<Record<string, number>> => {
  try {
    // Get the current fuel pump ID
    const fuelPumpId = await getFuelPumpId();
    
    if (!fuelPumpId) {
      console.log('getCurrentFuelLevels: No fuel pump ID available, cannot fetch fuel levels');
      return {};
    }
    
    console.log(`getCurrentFuelLevels: Fetching for fuel pump ${fuelPumpId}`);
    
    const { data, error } = await supabase
      .from('fuel_settings')
      .select('fuel_type, current_level, tank_capacity')
      .eq('fuel_pump_id', fuelPumpId);
      
    if (error) throw error;
    
    const fuelLevels: Record<string, number> = {};
    
    if (data && data.length > 0) {
      console.log(`getCurrentFuelLevels: Found ${data.length} fuel types for fuel pump ${fuelPumpId}`);
      
      data.forEach(fuel => {
        if (fuel.current_level !== null && fuel.tank_capacity !== null && fuel.tank_capacity > 0) {
          const percentage = (fuel.current_level / fuel.tank_capacity) * 100;
          fuelLevels[fuel.fuel_type] = Math.min(Math.round(percentage), 100);
        } else {
          fuelLevels[fuel.fuel_type] = 0;
        }
      });
    } else {
      console.log(`getCurrentFuelLevels: No fuel settings found for fuel pump ${fuelPumpId}`);
    }
    
    return fuelLevels;
  } catch (error) {
    console.error('Error fetching fuel levels:', error);
    return {};
  }
};

// Function to get dashboard metrics (shift-based)
export const getDashboardMetrics = async (startDate: Date, endDate: Date): Promise<DashboardMetrics> => {
  try {
    // Get the current fuel pump ID
    const fuelPumpId = await getFuelPumpId();
    
    if (!fuelPumpId) {
      console.log('getDashboardMetrics: No fuel pump ID available, cannot fetch metrics');
      return {
        totalSales: '₹0',
        customers: '0',
        fuelVolume: '0 L',
        growth: '0%'
      };
    }
    
    console.log(`getDashboardMetrics: Fetching shift-based metrics for fuel pump ${fuelPumpId}`);
    
    // Get total sales from completed shifts
    const { data: shiftsData, error: shiftsError } = await supabase
      .from('shifts')
      .select(`
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
      `)
      .eq('fuel_pump_id', fuelPumpId)
      .eq('status', 'completed')
      .gte('end_time', format(startDate, 'yyyy-MM-dd') + ' 00:00:00')
      .lte('end_time', format(endDate, 'yyyy-MM-dd') + ' 23:59:59');
      
    if (shiftsError) throw shiftsError;
    
    // Get customer count
    const { data: customerData, error: customerError } = await supabase
      .from('customers')
      .select('id')
      .eq('fuel_pump_id', fuelPumpId);
      
    if (customerError) throw customerError;
    
    // Calculate total sales and fuel volume from shifts
    let totalSales = 0;
    let totalFuelVolume = 0;
    
    if (shiftsData) {
      shiftsData.forEach(shift => {
        if (shift.readings && shift.readings.length > 0) {
          // Use first reading to avoid double counting - FUEL sales only
          const firstReading = shift.readings[0];
          totalSales += (Number(firstReading.cash_sales) || 0) +
                       (Number(firstReading.card_sales) || 0) +
                       (Number(firstReading.upi_sales) || 0) +
                       (Number(firstReading.others_sales) || 0) +
                       (Number(firstReading.indent_sales) || 0);
          // Note: consumable_expenses excluded from fuel sales metrics
          
          // Calculate fuel volume from all readings in the shift, subtracting testing fuel
          shift.readings.forEach(reading => {
            if (reading.closing_reading && reading.opening_reading) {
              const volumeDispensed = (Number(reading.closing_reading) - Number(reading.opening_reading)) || 0;
              const testingFuel = Number(reading.testing_fuel) || 0;
              totalFuelVolume += Math.max(0, volumeDispensed - testingFuel);
            }
          });
        }
      });
    }
    
    // Get previous period data for growth calculation (shift-based)
    const previousPeriodStart = new Date(startDate);
    const previousPeriodEnd = new Date(endDate);
    const daysDiff = Math.floor((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24));
    previousPeriodStart.setDate(previousPeriodStart.getDate() - daysDiff - 1);
    previousPeriodEnd.setDate(previousPeriodEnd.getDate() - daysDiff - 1);
    
    const { data: prevShiftsData, error: prevShiftsError } = await supabase
      .from('shifts')
      .select(`
        readings (
          cash_sales,
          card_sales,
          upi_sales,
          others_sales,
          indent_sales,
          consumable_expenses
        )
      `)
      .eq('fuel_pump_id', fuelPumpId)
      .eq('status', 'completed')
      .gte('end_time', format(previousPeriodStart, 'yyyy-MM-dd') + ' 00:00:00')
      .lte('end_time', format(previousPeriodEnd, 'yyyy-MM-dd') + ' 23:59:59');
      
    if (prevShiftsError) throw prevShiftsError;
    
    // Calculate previous period sales from shifts
    let prevTotalSales = 0;
    if (prevShiftsData) {
      prevShiftsData.forEach(shift => {
        if (shift.readings && shift.readings.length > 0) {
          const firstReading = shift.readings[0];
          prevTotalSales += (Number(firstReading.cash_sales) || 0) +
                           (Number(firstReading.card_sales) || 0) +
                           (Number(firstReading.upi_sales) || 0) +
                           (Number(firstReading.others_sales) || 0) +
                           (Number(firstReading.indent_sales) || 0);
          // Note: consumable_expenses excluded from fuel sales growth calculation
        }
      });
    }
    
    // Calculate growth percentage
    let growthPercentage = 0;
    if (prevTotalSales > 0) {
      growthPercentage = ((totalSales - prevTotalSales) / prevTotalSales) * 100;
    }
    
    console.log(`getDashboardMetrics: Metrics for fuel pump ${fuelPumpId}:`, {
      totalSales,
      customerCount: customerData?.length || 0,
      fuelVolume: totalFuelVolume,
      growth: growthPercentage
    });
    
    return {
      totalSales: `₹${totalSales.toLocaleString('en-IN')}`,
      customers: customerData?.length.toString() || '0',
      fuelVolume: `${Math.round(totalFuelVolume).toLocaleString('en-IN')} L`,
      growth: `${growthPercentage > 0 ? '+' : ''}${growthPercentage.toFixed(1)}%`
    };
  } catch (error) {
    console.error('Error fetching dashboard metrics:', error);
    return {
      totalSales: '₹0',
      customers: '0',
      fuelVolume: '0 L',
      growth: '0%'
    };
  }
};

// Function to get configured fuel types for current fuel pump
export const getConfiguredFuelTypes = async (): Promise<string[]> => {
  try {
    const fuelPumpId = await getFuelPumpId();
    
    if (!fuelPumpId) {
      console.log('getConfiguredFuelTypes: No fuel pump ID available');
      return [];
    }

    const { data, error } = await supabase
      .from('fuel_settings')
      .select('fuel_type')
      .eq('fuel_pump_id', fuelPumpId)
      .order('fuel_type');

    if (error) throw error;

    return data?.map(item => item.fuel_type) || [];
  } catch (error) {
    console.error('Error fetching configured fuel types:', error);
    return [];
  }
};

// Function to get transaction summary for a date range
export const getTransactionSummaryForDateRange = async (startDate: Date, endDate: Date): Promise<TodaysTransactionSummary> => {
  try {
    // Get the current fuel pump ID
    const fuelPumpId = await getFuelPumpId();
    
    if (!fuelPumpId) {
      console.log('getTransactionSummaryForDateRange: No fuel pump ID available');
      return {
        indentSales: { amount: '₹0', count: 0 },
        consumablesSales: { amount: '₹0', count: 0 },
        fuelTypeSales: {},
        total: { amount: '₹0', count: 0 }
      };
    }

    const formattedStartDate = format(startDate, 'yyyy-MM-dd');
    const formattedEndDate = format(endDate, 'yyyy-MM-dd');
    console.log(`getTransactionSummaryForDateRange: Fetching for fuel pump ${fuelPumpId} from ${formattedStartDate} to ${formattedEndDate}`);

    // Get configured fuel types
    const fuelTypes = await getConfiguredFuelTypes();

    // Get indent sales for the date range (transactions with payment_method = 'indent')
    const { data: indentData, error: indentError } = await supabase
      .from('transactions')
      .select('amount')
      .eq('fuel_pump_id', fuelPumpId)
      .gte('date', formattedStartDate)
      .lte('date', formattedEndDate)
      .eq('payment_method', 'indent');

    if (indentError) throw indentError;

    // Get consumables sales for the date range
    const { data: consumablesData, error: consumablesError } = await supabase
      .from('transaction_consumables')
      .select('total_amount')
      .eq('fuel_pump_id', fuelPumpId)
      .gte('created_at', `${formattedStartDate} 00:00:00`)
      .lt('created_at', `${formattedEndDate} 23:59:59`);

    if (consumablesError) throw consumablesError;

    // Get shift-based data for fuel sales (single source of truth - use only first reading per shift)
    const { data: shiftsData, error: shiftError } = await supabase
      .from('shifts')
      .select(`
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
      `)
      .eq('fuel_pump_id', fuelPumpId)
      .eq('status', 'completed')
      .gte('end_time', `${formattedStartDate} 00:00:00`)
      .lte('end_time', `${formattedEndDate} 23:59:59`);

    if (shiftError) throw shiftError;

    // Calculate indent sales
    const indentAmount = indentData?.reduce((sum, item) => sum + (Number(item.amount) || 0), 0) || 0;
    const indentCount = indentData?.length || 0;

    // Calculate consumables sales
    const consumablesAmount = consumablesData?.reduce((sum, item) => sum + (Number(item.total_amount) || 0), 0) || 0;
    const consumablesCount = consumablesData?.length || 0;

    // Calculate fuel type sales from shift-based data (single source of truth)
    const fuelTypeSales: Record<string, FuelTypeSales> = {};
    
    // Initialize all configured fuel types
    fuelTypes.forEach(fuelType => {
      fuelTypeSales[fuelType] = {
        volume: '0 L',
        amount: '₹0',
        count: 0
      };
    });

    // Create normalization mapping for robust fuel type matching
    const normalizeFuelType = (name: string) => name.toLowerCase().trim();
    const normalizedConfiguredTypes = new Map();
    fuelTypes.forEach(fuelType => {
      normalizedConfiguredTypes.set(normalizeFuelType(fuelType), fuelType);
    });

    // Process each completed shift, using only first reading for sales data
    shiftsData?.forEach(shift => {
      if (!shift.readings || shift.readings.length === 0) return;
      
      // Group readings by fuel type for this shift
      const readingsByFuelType: Record<string, any[]> = {};
      shift.readings.forEach(reading => {
        if (!reading.fuel_type) return;
        if (!readingsByFuelType[reading.fuel_type]) {
          readingsByFuelType[reading.fuel_type] = [];
        }
        readingsByFuelType[reading.fuel_type].push(reading);
      });
      
      // Process each fuel type in this shift
      Object.entries(readingsByFuelType).forEach(([fuelType, readings]) => {
        // Use FIRST reading for sales data to avoid double counting
        const firstReading = readings[0];
        const shiftSalesAmount = (Number(firstReading.card_sales) || 0) + 
                                (Number(firstReading.upi_sales) || 0) + 
                                (Number(firstReading.cash_sales) || 0) + 
                                (Number(firstReading.others_sales) || 0);
        
        // Sum volumes from ALL readings for this fuel type, subtracting testing fuel
        const totalVolume = readings.reduce((sum, reading) => {
          const volumeDispensed = Math.max(0, (Number(reading.closing_reading) || 0) - (Number(reading.opening_reading) || 0));
          const testingFuel = Number(reading.testing_fuel) || 0;
          return sum + Math.max(0, volumeDispensed - testingFuel);
        }, 0);
        
        // Match fuel type with configured types
        let matchedFuelType = fuelTypeSales[fuelType] ? fuelType : null;
        
        // If no exact match, try normalized matching
        if (!matchedFuelType) {
          const normalizedReading = normalizeFuelType(fuelType);
          matchedFuelType = normalizedConfiguredTypes.get(normalizedReading);
        }
        
        // If still no match, try contains matching for common fuel types
        if (!matchedFuelType) {
          const normalizedReading = normalizeFuelType(fuelType);
          if (normalizedReading.includes('petrol')) {
            matchedFuelType = fuelTypes.find(ft => normalizeFuelType(ft).includes('petrol'));
          } else if (normalizedReading.includes('diesel')) {
            matchedFuelType = fuelTypes.find(ft => normalizeFuelType(ft).includes('diesel'));
          }
        }
        
        // If still no match, create a new bucket
        if (!matchedFuelType) {
          matchedFuelType = fuelType;
          fuelTypeSales[matchedFuelType] = {
            volume: '0 L',
            amount: '₹0',
            count: 0
          };
          console.log(`getTransactionSummaryForDateRange: Created new fuel type bucket: ${matchedFuelType}`);
        }
        
        // Add to totals
        const currentAmount = parseFloat(fuelTypeSales[matchedFuelType].amount.replace('₹', '').replace(',', '')) || 0;
        const currentVolume = parseFormattedVolume(fuelTypeSales[matchedFuelType].volume);
        
        fuelTypeSales[matchedFuelType] = {
          volume: `${Math.round(currentVolume + totalVolume).toLocaleString()} L`,
          amount: `₹${Math.round(currentAmount + shiftSalesAmount).toLocaleString()}`,
          count: fuelTypeSales[matchedFuelType].count + 1
        };
      });
    });

    // Calculate total sales (fuel + consumables, indents already included in fuel)
    const totalFuelAmount = Object.values(fuelTypeSales).reduce((sum, fuel) => {
      return sum + (parseFloat(fuel.amount.replace('₹', '').replace(',', '')) || 0);
    }, 0);

    const totalAmount = totalFuelAmount + consumablesAmount;
    const totalCount = consumablesCount + 
                      Object.values(fuelTypeSales).reduce((sum, fuel) => sum + fuel.count, 0);

    // Debug logging for fuel type sales
    console.log(`getTransactionSummaryForDateRange: Fuel Type Sales Details:`, fuelTypeSales);
    Object.entries(fuelTypeSales).forEach(([fuelType, sales]) => {
      const volume = parseFormattedVolume(sales.volume);
      const amount = parseFloat(sales.amount.replace('₹', '').replace(',', '')) || 0;
      console.log(`getTransactionSummaryForDateRange: ${fuelType} - Volume: ${volume}L, Amount: ₹${amount}, Count: ${sales.count}`);
    });

    console.log(`getTransactionSummaryForDateRange: Summary for fuel pump ${fuelPumpId}:`, {
      indentAmount,
      indentCount,
      consumablesAmount,
      consumablesCount,
      fuelTypeSales,
      totalAmount,
      totalCount
    });

    return {
      indentSales: {
        amount: `₹${indentAmount.toLocaleString()}`,
        count: indentCount
      },
      consumablesSales: {
        amount: `₹${consumablesAmount.toLocaleString()}`,
        count: consumablesCount
      },
      fuelTypeSales,
      total: {
        amount: `₹${totalAmount.toLocaleString()}`,
        count: totalCount
      }
    };
  } catch (error) {
    console.error('Error fetching transaction summary for date range:', error);
    return {
      indentSales: { amount: '₹0', count: 0 },
      consumablesSales: { amount: '₹0', count: 0 },
      fuelTypeSales: {},
      total: { amount: '₹0', count: 0 }
    };
  }
};

// Function to get today's transaction summary (including shift sales and dynamic fuel types)
export const getTodaysTransactionSummary = async (): Promise<TodaysTransactionSummary> => {
  const today = new Date();
  return getTransactionSummaryForDateRange(today, today);
};

// Function to get today's fuel-wise sales breakdown
export const getTodaysFuelSalesBreakdown = async (): Promise<{
  petrol: { volume: string; amount: string };
  diesel: { volume: string; amount: string };
}> => {
  try {
    const fuelPumpId = await getCurrentUserFuelPumpId();
    
    if (!fuelPumpId) {
      return {
        petrol: { volume: '0 L', amount: '₹0' },
        diesel: { volume: '0 L', amount: '₹0' }
      };
    }

    const today = format(new Date(), 'yyyy-MM-dd');

    // Get today's fuel sales from daily_readings (subtract testing fuel for net volume)
    const { data: dailyReadings, error } = await supabase
      .from('daily_readings')
      .select('fuel_type, actual_meter_sales, testing_quantity')
      .eq('fuel_pump_id', fuelPumpId)
      .eq('date', today);

    if (error) throw error;

    // Get fuel prices for amount calculation
    const { data: fuelSettings } = await supabase
      .from('fuel_settings')
      .select('fuel_type, current_price')
      .eq('fuel_pump_id', fuelPumpId);

    const fuelPrices: Record<string, number> = {};
    fuelSettings?.forEach(setting => {
      fuelPrices[setting.fuel_type] = setting.current_price;
    });

    // Initialize totals
    const petrolData = { volume: 0, amount: 0 };
    const dieselData = { volume: 0, amount: 0 };

    // Process daily readings data (subtract testing fuel for net volume)
    dailyReadings?.forEach(reading => {
      const grossVolume = reading.actual_meter_sales || 0;
      const testingVolume = reading.testing_quantity || 0;
      const netVolume = Math.max(0, grossVolume - testingVolume);
      const price = fuelPrices[reading.fuel_type] || 0;
      const amount = netVolume * price;
      
      if (reading.fuel_type?.toLowerCase().includes('petrol')) {
        petrolData.volume += netVolume;
        petrolData.amount += amount;
      } else if (reading.fuel_type?.toLowerCase().includes('diesel')) {
        dieselData.volume += netVolume;
        dieselData.amount += amount;
      }
    });

    return {
      petrol: {
        volume: `${Math.round(petrolData.volume).toLocaleString()} L`,
        amount: `₹${Math.round(petrolData.amount).toLocaleString()}`
      },
      diesel: {
        volume: `${Math.round(dieselData.volume).toLocaleString()} L`,
        amount: `₹${Math.round(dieselData.amount).toLocaleString()}`
      }
    };
  } catch (error) {
    console.error('Error fetching today\'s fuel sales breakdown:', error);
    return {
      petrol: { volume: '0 L', amount: '₹0' },
      diesel: { volume: '0 L', amount: '₹0' }
    };
  }
};
