import 'package:expense_tracker_mobile/core/models/payment.model.dart';
import 'package:expense_tracker_mobile/core/theme/colors.dart';
import 'package:expense_tracker_mobile/shared/widgets/currency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChart extends StatelessWidget {
  final List<Payment> payments;
  final double totalExpense;

  const ExpenseChart({
    Key? key,
    required this.payments,
    required this.totalExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter payments to only include expenses (debit)
    final expensePayments = payments.where((p) => p.type == PaymentType.debit).toList();
    
    // Group expenses by category
    final Map<String, double> expensesByCategory = {};
    for (var payment in expensePayments) {
      final categoryName = payment.category.name;
      if (expensesByCategory.containsKey(categoryName)) {
        expensesByCategory[categoryName] = expensesByCategory[categoryName]! + payment.amount;
      } else {
        expensesByCategory[categoryName] = payment.amount;
      }
    }

    // Generate colors for each category
    final List<Color> categoryColors = [
      ThemeColors.error,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
      Colors.amberAccent,
      Colors.cyanAccent,
    ];

    // Create sections for the pie chart
    final sections = <PieChartSectionData>[];
    int colorIndex = 0;
    
    expensesByCategory.forEach((category, amount) {
      final percentage = totalExpense > 0 ? (amount / totalExpense) * 100 : 0;
      sections.add(
        PieChartSectionData(
          color: categoryColors[colorIndex % categoryColors.length],
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
            "Expense by Category",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          const SizedBox(height: 15),
          if (expensesByCategory.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("No expense data to display"),
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
                // Category legend
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: expensesByCategory.entries.map((entry) {
                    final index = expensesByCategory.keys.toList().indexOf(entry.key);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: categoryColors[index % categoryColors.length],
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