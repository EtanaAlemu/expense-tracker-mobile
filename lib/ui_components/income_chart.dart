import 'package:expense_tracker_mobile/core/models/payment.model.dart';
import 'package:expense_tracker_mobile/core/theme/colors.dart';
import 'package:expense_tracker_mobile/shared/widgets/currency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeChart extends StatelessWidget {
  final List<Payment> payments;
  final double totalIncome;

  const IncomeChart({
    Key? key,
    required this.payments,
    required this.totalIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter payments to only include income (credit)
    final incomePayments = payments.where((p) => p.type == PaymentType.credit).toList();
    
    // Group income by account
    final Map<String, double> incomeByAccount = {};
    for (var payment in incomePayments) {
      final accountName = payment.account.name;
      if (incomeByAccount.containsKey(accountName)) {
        incomeByAccount[accountName] = incomeByAccount[accountName]! + payment.amount;
      } else {
        incomeByAccount[accountName] = payment.amount;
      }
    }

    // Generate colors for each account
    final List<Color> accountColors = [
      ThemeColors.success,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
      Colors.amberAccent,
      Colors.cyanAccent,
    ];

    // Create sections for the pie chart
    final sections = <PieChartSectionData>[];
    int colorIndex = 0;
    
    incomeByAccount.forEach((account, amount) {
      final percentage = totalIncome > 0 ? (amount / totalIncome) * 100 : 0;
      sections.add(
        PieChartSectionData(
          color: accountColors[colorIndex % accountColors.length],
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Income by Account",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          const SizedBox(height: 15),
          if (incomeByAccount.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("No income data to display"),
              ),
            )
          else
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // You can add interaction here if needed
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Account legend
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: incomeByAccount.entries.map((entry) {
                    final index = incomeByAccount.keys.toList().indexOf(entry.key);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: accountColors[index % accountColors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          entry.key,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        CurrencyText(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }
} 