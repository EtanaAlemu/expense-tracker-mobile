import 'package:expense_tracker_mobile/core/models/payment.model.dart';
import 'package:expense_tracker_mobile/core/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyTrendChart extends StatelessWidget {
  final List<Payment> payments;
  final DateTimeRange dateRange;

  const MonthlyTrendChart({
    Key? key,
    required this.payments,
    required this.dateRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Organize data by day
    final Map<DateTime, Map<String, double>> dailyData = {};
    
    // Initialize dates within range
    DateTime current = DateTime(
      dateRange.start.year,
      dateRange.start.month,
      dateRange.start.day,
    );
    
    while (!current.isAfter(dateRange.end)) {
      dailyData[current] = {
        'income': 0.0,
        'expense': 0.0,
      };
      current = current.add(const Duration(days: 1));
    }
    
    // Populate the data
    for (var payment in payments) {
      final day = DateTime(
        payment.datetime.year,
        payment.datetime.month,
        payment.datetime.day,
      );
      
      if (dailyData.containsKey(day)) {
        if (payment.type == PaymentType.credit) {
          dailyData[day]!['income'] = (dailyData[day]!['income'] ?? 0) + payment.amount;
        } else {
          dailyData[day]!['expense'] = (dailyData[day]!['expense'] ?? 0) + payment.amount;
        }
      }
    }
    
    // Sort dates
    final sortedDates = dailyData.keys.toList()..sort();
    
    // Create income line chart spots
    final incomeSpots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      incomeSpots.add(FlSpot(i.toDouble(), dailyData[date]!['income']!));
    }
    
    // Create expense line chart spots
    final expenseSpots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      expenseSpots.add(FlSpot(i.toDouble(), dailyData[date]!['expense']!));
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Trend",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: sortedDates.isEmpty 
            ? const Center(child: Text("No data available for the selected period"))
            : LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                            final date = sortedDates[value.toInt()];
                            // Show date every few days depending on range
                            if (sortedDates.length <= 7 || value.toInt() % (sortedDates.length ~/ 5) == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('MMM d').format(date),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  minX: 0,
                  maxX: (sortedDates.length - 1).toDouble(),
                  lineBarsData: [
                    // Income line
                    LineChartBarData(
                      spots: incomeSpots,
                      isCurved: true,
                      color: ThemeColors.success,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: ThemeColors.success.withOpacity(0.2),
                      ),
                    ),
                    // Expense line
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: true,
                      color: ThemeColors.error,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: ThemeColors.error.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
          ),
          const SizedBox(height: 20),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: ThemeColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('Income'),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: ThemeColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('Expense'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
} 