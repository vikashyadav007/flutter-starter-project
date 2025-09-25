import React, { useState, useEffect } from 'react';
import { MobileHeader } from '@/components/mobile/MobileHeader';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { DateFilterDropdown, DateFilterOption } from '@/components/shared/DateFilterDropdown';
import { useDynamicFuelTypes } from '@/hooks/useDynamicFuelTypes';
import { supabase } from '@/integrations/supabase/client';
import { getFuelPumpId } from '@/integrations/utils';
import { getTransactionSummaryForDateRange } from '@/utils/dashboardUtils';
import { formatIndianCurrency, formatIndianQuantity, parseIndianCurrency } from '@/utils/numberFormat';
import { parseFormattedVolume } from '@/utils/formatUtils';
import { DateRange } from 'react-day-picker';
import { subDays, startOfMonth, format } from 'date-fns';
import { 
  TrendingUp, 
  Fuel, 
  CreditCard, 
  Wallet, 
  ShoppingCart,
  Loader2,
  Users,
  Clock,
  Activity,
  ArrowUpRight
} from 'lucide-react';

interface DashboardMetrics {
  salesAmount: number;
  fuelVolume: number;
  fuelVolumeByType: Record<string, number>;
  indentSalesAmount: number;
  customerPayments: number;
  consumablesSales: number;
  activeShifts: number;
  pendingApprovals: number;
  transactionCount: number;
}

const MobileDashboard = () => {
  const [selectedPeriod, setSelectedPeriod] = useState<DateFilterOption>('monthtodate');
  const [customDateRange, setCustomDateRange] = useState<DateRange>();
  const [metrics, setMetrics] = useState<DashboardMetrics>({
    salesAmount: 0,
    fuelVolume: 0,
    fuelVolumeByType: {},
    indentSalesAmount: 0,
    customerPayments: 0,
    consumablesSales: 0,
    activeShifts: 0,
    pendingApprovals: 0,
    transactionCount: 0
  });
  const [isLoading, setIsLoading] = useState(true);
  const { fuelTypes, isLoading: fuelTypesLoading } = useDynamicFuelTypes();

  const getDateRange = (period: DateFilterOption, customRange?: DateRange) => {
    const today = new Date();
    
    switch (period) {
      case 'today':
        return { startDate: today, endDate: today };
      case 'yesterday':
        const yesterday = subDays(today, 1);
        return { startDate: yesterday, endDate: yesterday };
      case 'last7days':
        return { startDate: subDays(today, 6), endDate: today };
      case 'monthtodate':
        return { startDate: startOfMonth(today), endDate: today };
      case 'custom':
        if (customRange?.from) {
          return { 
            startDate: customRange.from, 
            endDate: customRange.to || customRange.from 
          };
        }
        return { startDate: today, endDate: today };
      default:
        return { startDate: today, endDate: today };
    }
  };

  const fetchMetrics = async () => {
    try {
      setIsLoading(true);
      const fuelPumpId = await getFuelPumpId();
      if (!fuelPumpId) return;

      const { startDate, endDate } = getDateRange(selectedPeriod, customDateRange);
      
      // Fetch transaction summary
      const transactionSummary = await getTransactionSummaryForDateRange(startDate, endDate);
      
      // Fetch customer payments
      const { data: paymentsData, error: paymentsError } = await supabase
        .from('customer_payments')
        .select('amount')
        .eq('fuel_pump_id', fuelPumpId)
        .gte('date', format(startDate, 'yyyy-MM-dd'))
        .lte('date', format(endDate, 'yyyy-MM-dd'));

      if (paymentsError) {
        console.error('Error fetching customer payments:', paymentsError);
      }

      // Fetch active shifts
      const { data: activeShiftsData, error: shiftsError } = await supabase
        .from('shifts')
        .select('id')
        .eq('fuel_pump_id', fuelPumpId)
        .is('end_time', null);

      if (shiftsError) {
        console.error('Error fetching active shifts:', shiftsError);
      }

      // Fetch pending indent approvals
      const { data: pendingApprovalsData, error: approvalsError } = await supabase
        .from('indents')
        .select('id')
        .eq('fuel_pump_id', fuelPumpId)
        .eq('status', 'Pending');

      if (approvalsError) {
        console.error('Error fetching pending approvals:', approvalsError);
      }

      const customerPaymentsTotal = paymentsData?.reduce((sum, payment) => 
        sum + (payment.amount || 0), 0) || 0;

      // Extract fuel volume by type
      const fuelVolumeByType: Record<string, number> = {};
      let totalFuelVolume = 0;

      if (transactionSummary.fuelTypeSales) {
        Object.entries(transactionSummary.fuelTypeSales).forEach(([fuelType, data]) => {
          if (data && typeof data === 'object' && 'volume' in data) {
            const volume = parseFormattedVolume(data.volume);
            fuelVolumeByType[fuelType] = volume;
            totalFuelVolume += volume;
          }
        });
      }

      // Calculate transaction count
      const transactionCount = transactionSummary.total.count || 0;

      setMetrics({
        salesAmount: parseIndianCurrency(transactionSummary.total.amount),
        fuelVolume: totalFuelVolume,
        fuelVolumeByType,
        indentSalesAmount: parseIndianCurrency(transactionSummary.indentSales.amount),
        customerPayments: customerPaymentsTotal,
        consumablesSales: parseIndianCurrency(transactionSummary.consumablesSales.amount),
        activeShifts: activeShiftsData?.length || 0,
        pendingApprovals: pendingApprovalsData?.length || 0,
        transactionCount
      });

    } catch (error) {
      console.error('Error fetching dashboard metrics:', error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchMetrics();
  }, [selectedPeriod, customDateRange]);

  const handleDateFilterChange = (option: DateFilterOption, dateRange?: DateRange) => {
    setSelectedPeriod(option);
    if (option === 'custom' && dateRange) {
      setCustomDateRange(dateRange);
    }
  };

  const MetricCard = ({ 
    title, 
    value, 
    icon, 
    gradient = "from-primary/10 to-primary/5",
    iconColor = "text-primary" 
  }: { 
    title: string; 
    value: string; 
    icon: React.ReactNode; 
    gradient?: string;
    iconColor?: string;
  }) => (
    <Card className="relative overflow-hidden">
      <div className={`absolute inset-0 bg-gradient-to-br ${gradient}`} />
      <CardContent className="relative p-4">
        <div className="flex items-center justify-between">
          <div className="space-y-1">
            <p className="text-sm font-medium text-muted-foreground">{title}</p>
            <p className="text-xl font-bold">{value}</p>
          </div>
          <div className={`p-2 rounded-lg bg-background/50 ${iconColor}`}>
            {icon}
          </div>
        </div>
      </CardContent>
    </Card>
  );

  const HeroCard = ({ 
    title, 
    value, 
    icon, 
    trend 
  }: { 
    title: string; 
    value: string; 
    icon: React.ReactNode; 
    trend?: string;
  }) => (
    <Card className="relative overflow-hidden bg-gradient-to-br from-primary to-primary/80 text-primary-foreground">
      <CardContent className="p-6">
        <div className="flex items-center justify-between mb-2">
          <div className="p-3 rounded-lg bg-white/10">
            {icon}
          </div>
          {trend && (
            <div className="flex items-center gap-1 text-sm">
              <ArrowUpRight className="h-4 w-4" />
              {trend}
            </div>
          )}
        </div>
        <div className="space-y-1">
          <p className="text-sm opacity-90">{title}</p>
          <p className="text-3xl font-bold">{value}</p>
        </div>
      </CardContent>
    </Card>
  );


  if (isLoading && fuelTypesLoading) {
    return (
      <div className="container mx-auto py-4 px-3 flex flex-col min-h-screen">
        <MobileHeader title="Dashboard" />
        <div className="flex flex-col items-center justify-center h-64">
          <Loader2 className="h-8 w-8 animate-spin text-primary mb-4" />
          <p className="text-muted-foreground">Loading dashboard...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-4 px-3 flex flex-col min-h-screen">
      <MobileHeader title="Dashboard" />
      
      {/* Date Filter */}
      <div className="mb-6">
        <DateFilterDropdown
          value={selectedPeriod}
          onChange={handleDateFilterChange}
          customDateRange={customDateRange}
        />
      </div>

      {/* Metrics Grid */}
      <div className="space-y-4 mb-6">
        {/* Hero Card - Total Sales */}
        <HeroCard
          title="Total Sales"
          value={formatIndianCurrency(metrics.salesAmount)}
          icon={<TrendingUp className="h-6 w-6" />}
        />

        {/* 2x2 Grid for main metrics */}
        <div className="grid grid-cols-2 gap-3">
          {/* Fuel Volume - Special card with breakdown */}
          <Card className="relative overflow-hidden col-span-2">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-500/10 to-blue-500/5" />
            <CardHeader className="relative pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground flex items-center gap-2">
                <Fuel className="h-4 w-4 text-blue-500" />
                Fuel Volume
              </CardTitle>
            </CardHeader>
            <CardContent className="relative pt-0">
              <div className="space-y-2">
                <p className="text-xl font-bold">
                  {formatIndianQuantity(metrics.fuelVolume, 'L')}
                </p>
                <div className="grid grid-cols-2 gap-2">
                  {Object.entries(metrics.fuelVolumeByType).map(([fuelType, volume]) => (
                    <div key={fuelType} className="flex justify-between text-sm bg-background/50 rounded p-2">
                      <span className="text-muted-foreground">{fuelType}:</span>
                      <span className="font-medium">{formatIndianQuantity(volume, 'L')}</span>
                    </div>
                  ))}
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Indent Sales */}
          <MetricCard
            title="Indent Sales"
            value={formatIndianCurrency(metrics.indentSalesAmount)}
            icon={<CreditCard className="h-5 w-5" />}
            gradient="from-blue-500/10 to-blue-500/5"
            iconColor="text-blue-500"
          />

          {/* Customer Payments */}
          <MetricCard
            title="Customer Payments"
            value={formatIndianCurrency(metrics.customerPayments)}
            icon={<Wallet className="h-5 w-5" />}
            gradient="from-purple-500/10 to-purple-500/5"
            iconColor="text-purple-500"
          />

          {/* Consumables Sales */}
          <MetricCard
            title="Consumables Sales"
            value={formatIndianCurrency(metrics.consumablesSales)}
            icon={<ShoppingCart className="h-5 w-5" />}
            gradient="from-orange-500/10 to-orange-500/5"
            iconColor="text-orange-500"
          />

          {/* Active Shifts & Pending Approvals */}
          <Card className="relative overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-green-500/10 to-yellow-500/10" />
            <CardContent className="relative p-4">
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs font-medium text-muted-foreground">Active Shifts</p>
                    <p className="text-lg font-bold">{metrics.activeShifts}</p>
                  </div>
                  <Users className="h-4 w-4 text-green-600" />
                </div>
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs font-medium text-muted-foreground">Pending Approvals</p>
                    <p className="text-lg font-bold text-orange-600">{metrics.pendingApprovals}</p>
                  </div>
                  <Clock className="h-4 w-4 text-orange-600" />
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Transaction Count */}
          <MetricCard
            title="Total Transactions"
            value={metrics.transactionCount.toString()}
            icon={<Activity className="h-5 w-5" />}
            gradient="from-indigo-500/10 to-indigo-500/5"
            iconColor="text-indigo-500"
          />
        </div>
      </div>

      {isLoading && (
        <div className="flex justify-center items-center py-4">
          <Loader2 className="h-6 w-6 animate-spin text-primary mr-2" />
          <span className="text-sm text-muted-foreground">Updating metrics...</span>
        </div>
      )}
    </div>
  );
};

export default MobileDashboard;