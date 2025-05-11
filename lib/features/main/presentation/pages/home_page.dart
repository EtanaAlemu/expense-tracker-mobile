import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/core/widgets/currency_text.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load transactions and categories when the page is opened
    context.read<TransactionBloc>().add(GetTransactions());
    context.read<CategoryBloc>().add(GetCategories());
  }

  String _getTimeBasedGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final l10n = AppLocalizations.of(context);

    if (hour < 12) {
      return l10n.get('good_morning');
    } else if (hour < 17) {
      return l10n.get('good_afternoon');
    } else {
      return l10n.get('good_evening');
    }
  }

  double _calculateTotalIncome(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == 'Income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateTotalExpense(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == 'Expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateBalance(List<Transaction> transactions) {
    return _calculateTotalIncome(transactions) -
        _calculateTotalExpense(transactions);
  }

  double _calculateSavingsRate(List<Transaction> transactions) {
    final income = _calculateTotalIncome(transactions);
    if (income == 0) return 0;
    return (_calculateBalance(transactions) / income) * 100;
  }

  Map<String, double> _calculateCategoryExpenses(
      List<Transaction> transactions) {
    final categoryTotals = <String, double>{};
    for (var transaction in transactions) {
      if (transaction.type == 'Expense') {
        categoryTotals[transaction.categoryId] =
            (categoryTotals[transaction.categoryId] ?? 0) + transaction.amount;
      }
    }
    return categoryTotals;
  }

  String _getTopExpenseCategory(
      List<Transaction> transactions, List<Category> categories) {
    final categoryTotals = _calculateCategoryExpenses(transactions);
    if (categoryTotals.isEmpty) return '';

    String topCategoryId = '';
    double maxAmount = 0;

    categoryTotals.forEach((categoryId, amount) {
      if (amount > maxAmount) {
        maxAmount = amount;
        topCategoryId = categoryId;
      }
    });

    final category = categories.firstWhere(
      (c) => c.id == topCategoryId,
      orElse: () => Category(
        id: '',
        name: '',
        type: '',
        color: Colors.grey,
        icon: Icons.category,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: '',
      ),
    );

    return category.name;
  }

  String _getFinancialHealthMessage(double savingsRate) {
    if (savingsRate >= 20) {
      return 'Excellent savings rate! Keep up the good work.';
    } else if (savingsRate >= 10) {
      return 'Good savings rate. Consider increasing it to 20%.';
    } else if (savingsRate >= 0) {
      return 'Try to increase your savings rate to at least 10%.';
    } else {
      return 'Your expenses exceed your income. Review your spending.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, transactionState) {
        if (transactionState is TransactionLoading) {
          return Center(child: Text(l10n.get('loading')));
        }

        if (transactionState is TransactionError) {
          return Center(
              child: Text('${l10n.get('error')}: ${transactionState.message}'));
        }

        if (transactionState is TransactionLoaded) {
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              if (categoryState is CategoryLoading) {
                return Center(child: Text(l10n.get('loading')));
              }

              if (categoryState is CategoryError) {
                return Center(
                    child:
                        Text('${l10n.get('error')}: ${categoryState.message}'));
              }

              if (categoryState is CategoryLoaded) {
                final transactions = transactionState.transactions;
                final categories = categoryState.categories;
                final totalIncome = _calculateTotalIncome(transactions);
                final totalExpense = _calculateTotalExpense(transactions);
                final balance = _calculateBalance(transactions);
                final savingsRate = _calculateSavingsRate(transactions);
                final topCategory =
                    _getTopExpenseCategory(transactions, categories);

                return Scaffold(
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        top: 48.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.waving_hand_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BlocBuilder<AuthBloc, AuthState>(
                                          builder: (context, state) {
                                            final userName =
                                                state.user?.firstName ??
                                                    l10n.get('there');
                                            return Text(
                                              '${_getTimeBasedGreeting(context)}, $userName!',
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            );
                                          },
                                        ),
                                        Text(
                                          l10n.get('financial_overview'),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (transactions.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Financial Health',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _getFinancialHealthMessage(savingsRate),
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      if (topCategory.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          'Top spending category: $topCategory',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Summary Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                context,
                                l10n.get('total_balance'),
                                balance,
                                Icons.account_balance_wallet,
                                theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                context,
                                l10n.get('income'),
                                totalIncome,
                                Icons.arrow_upward,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                context,
                                l10n.get('expenses'),
                                totalExpense,
                                Icons.arrow_downward,
                                Colors.red,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                context,
                                'Savings Rate',
                                savingsRate,
                                Icons.savings,
                                Colors.blue,
                                isPercentage: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Monthly Trend Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.get('monthly_trend'),
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMMM yyyy')
                                        .format(DateTime.now()),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      horizontalInterval: 1000,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey.withOpacity(0.2),
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: theme.textTheme.bodySmall,
                                            );
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: theme.textTheme.bodySmall,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      // Income Trend
                                      LineChartBarData(
                                        spots: _generateMonthlyTrendSpots(
                                            transactions, 'Income'),
                                        isCurved: true,
                                        color: Colors.green,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.green.withOpacity(0.1),
                                        ),
                                      ),
                                      // Expense Trend
                                      LineChartBarData(
                                        spots: _generateMonthlyTrendSpots(
                                            transactions, 'Expense'),
                                        isCurved: true,
                                        color: Colors.red,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.red.withOpacity(0.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildTrendIndicator(
                                      context,
                                      l10n.get('income_trend'),
                                      Colors.green,
                                      _calculateTrendPercentage(
                                          transactions, 'Income'),
                                    ),
                                    const SizedBox(width: 24),
                                    _buildTrendIndicator(
                                      context,
                                      l10n.get('expense_trend'),
                                      Colors.red,
                                      _calculateTrendPercentage(
                                          transactions, 'Expense'),
                                    ),
                                    const SizedBox(width: 24),
                                    _buildTrendIndicator(
                                      context,
                                      l10n.get('savings_trend'),
                                      Colors.blue,
                                      _calculateTrendPercentage(
                                          transactions, 'Savings'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Recent Transactions Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.get('recent_transactions'),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to all transactions
                              },
                              child: Text(
                                'View All',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (transactions.isEmpty)
                          _buildEmptyTransactionsList(context)
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transactions.length > 5
                                ? 5
                                : transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              return TransactionListItem(
                                transaction: transaction,
                                onTap: () {
                                  // TODO: Navigate to transaction details
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double amount,
    IconData icon,
    Color color, {
    bool isPercentage = false,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isPercentage)
              Text(
                '${amount.toStringAsFixed(1)}%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              CurrencyText(
                amount,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(
    BuildContext context,
    String title,
    Color color,
    double percentage,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isPositive = percentage > 0;
    final isNegative = percentage < 0;
    final direction = isPositive
        ? l10n.get('trend_up')
        : isNegative
            ? l10n.get('trend_down')
            : l10n.get('trend_stable');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n
                .get('percentage_change')
                .replaceAll(
                  '{percentage}',
                  percentage.abs().toStringAsFixed(1),
                )
                .replaceAll('{direction}', direction),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isPositive
                  ? Colors.green
                  : isNegative
                      ? Colors.red
                      : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactionsList(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 48,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.get('no_transactions'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.get('add_transaction_to_get_started'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateMonthlyTrendSpots(
    List<Transaction> transactions,
    String type,
  ) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Create a map to store daily totals
    final dailyTotals = <int, double>{};
    for (var i = 1; i <= daysInMonth; i++) {
      dailyTotals[i] = 0;
    }

    // Calculate daily totals
    for (var transaction in transactions) {
      if (transaction.type == type &&
          transaction.date
              .isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
          transaction.date
              .isBefore(lastDayOfMonth.add(const Duration(days: 1)))) {
        final day = transaction.date.day;
        dailyTotals[day] = (dailyTotals[day] ?? 0) + transaction.amount;
      }
    }

    // Generate spots
    return dailyTotals.entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  double _calculateTrendPercentage(
    List<Transaction> transactions,
    String type,
  ) {
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0);
    final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDayOfLastMonth = DateTime(now.year, now.month, 0);

    double currentMonthTotal = 0;
    double lastMonthTotal = 0;

    for (var transaction in transactions) {
      if (transaction.type == type) {
        if (transaction.date.isAfter(
                firstDayOfCurrentMonth.subtract(const Duration(days: 1))) &&
            transaction.date
                .isBefore(lastDayOfCurrentMonth.add(const Duration(days: 1)))) {
          currentMonthTotal += transaction.amount;
        } else if (transaction.date.isAfter(
                firstDayOfLastMonth.subtract(const Duration(days: 1))) &&
            transaction.date
                .isBefore(lastDayOfLastMonth.add(const Duration(days: 1)))) {
          lastMonthTotal += transaction.amount;
        }
      }
    }

    if (lastMonthTotal == 0) return 0;
    return ((currentMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
  }
}
