import 'package:expense_tracker/features/transaction/presentation/pages/edit_transaction_page.dart';
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
import 'package:expense_tracker/features/transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart'
    as get_transactions;
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart'
    as add_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/update_transaction.dart'
    as update_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/delete_transaction.dart'
    as delete_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/sync_transactions.dart'
    as sync_transactions;
import 'package:expense_tracker/features/category/domain/usecases/get_category.dart'
    as get_category;
import 'package:expense_tracker/core/services/notification/notification_service.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

enum TimePeriod { day, week, month, year }

class HomePage extends StatefulWidget {
  final VoidCallback onViewAll;

  const HomePage({super.key, required this.onViewAll});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimePeriod _selectedPeriod = TimePeriod.month;

  @override
  void initState() {
    super.initState();
    // Load transactions and categories when the page is opened
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user != null) {
      context.read<TransactionBloc>().add(GetTransactions());
      context.read<CategoryBloc>().add(GetCategories());
    }
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

  String _getFinancialHealthMessageKey(double savingsRate) {
    if (savingsRate >= 20) {
      return 'excellent_savings_rate';
    } else if (savingsRate >= 10) {
      return 'good_savings_rate';
    } else if (savingsRate >= 0) {
      return 'try_increase_savings_rate';
    } else {
      return 'expenses_exceed_income';
    }
  }

  List<Transaction> _filterTransactionsByPeriod(
      List<Transaction> transactions) {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case TimePeriod.day:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case TimePeriod.week:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case TimePeriod.month:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case TimePeriod.year:
        startDate = DateTime(now.year, 1, 1);
        break;
    }

    return transactions.where((t) => t.date.isAfter(startDate)).toList();
  }

  String _getPeriodTitle() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case TimePeriod.day:
        return DateFormat('EEEE, MMMM d').format(now);
      case TimePeriod.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d').format(endOfWeek)}';
      case TimePeriod.month:
        return DateFormat('MMMM yyyy').format(now);
      case TimePeriod.year:
        return now.year.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated && authState.user != null) {
          return BlocProvider(
            create: (context) => TransactionBloc(
              getTransactions: getIt<get_transactions.GetTransactions>(),
              addTransaction: getIt<add_transaction.AddTransaction>(),
              updateTransaction: getIt<update_transaction.UpdateTransaction>(),
              deleteTransaction: getIt<delete_transaction.DeleteTransaction>(),
              syncTransactions: getIt<sync_transactions.SyncTransactions>(),
              authRepository: getIt<AuthRepository>(),
              getCategory: getIt<get_category.GetCategory>(),
              notificationService: getIt<NotificationService>(),
            )..add(GetTransactions()),
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, transactionState) {
                if (transactionState is TransactionLoading) {
                  return Center(child: Text(l10n.get('loading')));
                }

                if (transactionState is TransactionError) {
                  return Center(
                      child: Text(
                          '${l10n.get('error')}: ${transactionState.message}'));
                }

                if (transactionState is TransactionLoaded) {
                  return BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, categoryState) {
                      if (categoryState is CategoryLoading) {
                        return Center(child: Text(l10n.get('loading')));
                      }

                      if (categoryState is CategoryError) {
                        return Center(
                            child: Text(
                                '${l10n.get('error')}: ${categoryState.error}'));
                      }

                      if (categoryState is CategoryLoaded) {
                        final filteredTransactions =
                            _filterTransactionsByPeriod(
                                transactionState.transactions);
                        final categories = categoryState.categories;
                        final totalIncome =
                            _calculateTotalIncome(filteredTransactions);
                        final totalExpense =
                            _calculateTotalExpense(filteredTransactions);
                        final balance = _calculateBalance(filteredTransactions);
                        final savingsRate =
                            _calculateSavingsRate(filteredTransactions);
                        final topCategory = _getTopExpenseCategory(
                            filteredTransactions, categories ?? []);

                        return Scaffold(
                          body: SingleChildScrollView(
                            padding: const EdgeInsets.only(
                                top: 48.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Welcome Section
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.shadow
                                            .withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                BlocBuilder<AuthBloc,
                                                    AuthState>(
                                                  builder: (context, state) {
                                                    final userName =
                                                        state.user?.firstName ??
                                                            l10n.get('there');
                                                    return Text(
                                                      '${_getTimeBasedGreeting(context)}, $userName!',
                                                      style: theme
                                                          .textTheme.titleLarge
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: theme.colorScheme
                                                            .primary,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  l10n.get(
                                                      'financial_overview'),
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.onSurface
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      if (filteredTransactions.isNotEmpty) ...[
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.surface,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: theme.colorScheme.outline
                                                  .withOpacity(0.1),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.get('financial_health'),
                                                style: theme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme
                                                      .colorScheme.onSurface,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                l10n.get(
                                                    _getFinancialHealthMessageKey(
                                                        savingsRate)),
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                              if (topCategory.isNotEmpty) ...[
                                                const SizedBox(height: 8),
                                                Text(
                                                  l10n.get(
                                                          'top_spending_category') +
                                                      ': $topCategory',
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.primary,
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
                                        l10n.get('savings_rate'),
                                        savingsRate,
                                        Icons.savings,
                                        Colors.blue,
                                        isPercentage: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Time Period Selector
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getPeriodTitle(),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildTimePeriodSelector(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Trend Chart
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.shadow
                                            .withOpacity(0.1),
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
                                        l10n.get('trend_analysis'),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
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
                                              getDrawingHorizontalLine:
                                                  (value) {
                                                return FlLine(
                                                  color: theme
                                                      .colorScheme.outline
                                                      .withOpacity(0.2),
                                                  strokeWidth: 1,
                                                );
                                              },
                                            ),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return Text(
                                                      value.toInt().toString(),
                                                      style: theme
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        color: theme.colorScheme
                                                            .onSurface
                                                            .withOpacity(0.7),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return Text(
                                                      value.toInt().toString(),
                                                      style: theme
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        color: theme.colorScheme
                                                            .onSurface
                                                            .withOpacity(0.7),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            borderData:
                                                FlBorderData(show: false),
                                            lineBarsData: [
                                              // Income Trend
                                              LineChartBarData(
                                                spots: _generateTrendSpots(
                                                    filteredTransactions,
                                                    'Income'),
                                                isCurved: true,
                                                color: Colors.green,
                                                barWidth: 3,
                                                isStrokeCapRound: true,
                                                dotData: FlDotData(show: false),
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  color: Colors.green
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                              // Expense Trend
                                              LineChartBarData(
                                                spots: _generateTrendSpots(
                                                    filteredTransactions,
                                                    'Expense'),
                                                isCurved: true,
                                                color: Colors.red,
                                                barWidth: 3,
                                                isStrokeCapRound: true,
                                                dotData: FlDotData(show: false),
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  color: Colors.red
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Category Distribution (Spending by Category)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.shadow
                                            .withOpacity(0.1),
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
                                        l10n.get('spending_by_category'),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CurrencyText(
                                        _calculateTotalExpense(
                                            filteredTransactions),
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 64),
                                      if (filteredTransactions.isEmpty)
                                        _buildEmptyCategoryDistribution(context)
                                      else ...[
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 64,
                                            width: 64,
                                            child: PieChart(
                                              PieChartData(
                                                sections:
                                                    _generateCategorySections(
                                                        filteredTransactions,
                                                        categories ?? []),
                                                sectionsSpace: 1,
                                                centerSpaceRadius: 18,
                                                startDegreeOffset: -90,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildSimplifiedCategoryLegend(
                                            filteredTransactions,
                                            categories ?? []),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Income by Category
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.shadow
                                            .withOpacity(0.1),
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
                                        l10n.get('income_by_category'),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CurrencyText(
                                        _calculateTotalIncome(
                                            filteredTransactions),
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 64),
                                      if (filteredTransactions
                                          .where((t) => t.type == 'Income')
                                          .isEmpty)
                                        _buildEmptyCategoryDistribution(context)
                                      else ...[
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 64,
                                            width: 64,
                                            child: PieChart(
                                              PieChartData(
                                                sections:
                                                    _generateIncomeCategorySections(
                                                        filteredTransactions,
                                                        categories ?? []),
                                                sectionsSpace: 1,
                                                centerSpaceRadius: 18,
                                                startDegreeOffset: -90,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildSimplifiedIncomeCategoryLegend(
                                            filteredTransactions,
                                            categories ?? []),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Recent Transactions
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.get('recent_transactions'),
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: widget.onViewAll,
                                      child: Text(
                                        l10n.get('view_all'),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (filteredTransactions.isEmpty)
                                  _buildEmptyTransactionsList(context)
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredTransactions.length > 5
                                        ? 5
                                        : filteredTransactions.length,
                                    itemBuilder: (context, index) {
                                      final transaction =
                                          filteredTransactions[index];
                                      return TransactionListItem(
                                        transaction: transaction,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditTransactionPage(
                                                  transaction: transaction,
                                                ),
                                              ));
                                        },
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          floatingActionButton: FloatingActionButton.extended(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddTransactionPage(),
                                ),
                              );

                              if (result == true) {
                                // Only refresh if a transaction was added
                                if (mounted) {
                                  context
                                      .read<TransactionBloc>()
                                      .add(GetTransactions());
                                }
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.get('add_transaction')),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.endFloat,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<FlSpot> _generateTrendSpots(
      List<Transaction> transactions, String type) {
    final spots = <FlSpot>[];
    final now = DateTime.now();
    int numberOfPoints;

    switch (_selectedPeriod) {
      case TimePeriod.day:
        numberOfPoints = 24; // Hours in a day
        break;
      case TimePeriod.week:
        numberOfPoints = 7; // Days in a week
        break;
      case TimePeriod.month:
        numberOfPoints =
            DateTime(now.year, now.month + 1, 0).day; // Days in month
        break;
      case TimePeriod.year:
        numberOfPoints = 12; // Months in a year
        break;
    }

    for (var i = 0; i < numberOfPoints; i++) {
      double total = 0;
      for (var transaction in transactions) {
        if (transaction.type == type) {
          switch (_selectedPeriod) {
            case TimePeriod.day:
              if (transaction.date.hour == i) {
                total += transaction.amount;
              }
              break;
            case TimePeriod.week:
              if (transaction.date.weekday == i + 1) {
                total += transaction.amount;
              }
              break;
            case TimePeriod.month:
              if (transaction.date.day == i + 1) {
                total += transaction.amount;
              }
              break;
            case TimePeriod.year:
              if (transaction.date.month == i + 1) {
                total += transaction.amount;
              }
              break;
          }
        }
      }
      spots.add(FlSpot(i.toDouble(), total));
    }

    return spots;
  }

  List<PieChartSectionData> _generateCategorySections(
    List<Transaction> transactions,
    List<Category> categories,
  ) {
    final categoryTotals = _calculateCategoryExpenses(transactions);
    final sections = <PieChartSectionData>[];
    final totalExpense = _calculateTotalExpense(transactions);
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Only show top 3 categories, combine the rest into "Others"
    final topCategories = sortedCategories.take(3).toList();
    double othersTotal = 0;

    for (var entry in sortedCategories) {
      if (topCategories.contains(entry)) {
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
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

        final percentage = entry.value / totalExpense * 100;
        sections.add(
          PieChartSectionData(
            color: category.color,
            value: entry.value,
            title: percentage >= 10 ? '${percentage.toStringAsFixed(0)}%' : '',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      } else {
        othersTotal += entry.value;
      }
    }

    // Add "Others" section if there are remaining categories
    if (othersTotal > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: othersTotal,
          title: '',
          radius: 100,
        ),
      );
    }

    return sections;
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
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

  Widget _buildEmptyTransactionsList(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
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

  Widget _buildTimePeriodSelector() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTimePeriodOption(
            TimePeriod.day,
            Icons.calendar_today,
            'Day',
            _selectedPeriod == TimePeriod.day,
          ),
          _buildTimePeriodOption(
            TimePeriod.week,
            Icons.calendar_view_week,
            'Week',
            _selectedPeriod == TimePeriod.week,
          ),
          _buildTimePeriodOption(
            TimePeriod.month,
            Icons.calendar_month,
            'Month',
            _selectedPeriod == TimePeriod.month,
          ),
          _buildTimePeriodOption(
            TimePeriod.year,
            Icons.calendar_view_day,
            'Year',
            _selectedPeriod == TimePeriod.year,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodOption(
    TimePeriod period,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPeriod = period;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minWidth: 80),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCategoryDistribution(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart,
            size: 48,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.get('no_expenses_to_display'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.get('add_expenses_to_see_distribution'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSimplifiedCategoryLegend(
    List<Transaction> transactions,
    List<Category> categories,
  ) {
    final categoryTotals = _calculateCategoryExpenses(transactions);
    final totalExpense = _calculateTotalExpense(transactions);
    final sorted = categoryTotals.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sorted.take(3).map((entry) {
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
          orElse: () => Category(
            id: '',
            name: AppLocalizations.of(context).get('other'),
            type: '',
            color: Colors.grey,
            icon: Icons.category,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: '',
          ),
        );
        final percent = (entry.value / totalExpense * 100).round();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: category.color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(category.name,
                      style: Theme.of(context).textTheme.bodyMedium)),
              Text('$percent%',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, double> _calculateIncomeCategoryTotals(
      List<Transaction> transactions) {
    final categoryTotals = <String, double>{};
    for (var transaction in transactions) {
      if (transaction.type == 'Income') {
        categoryTotals[transaction.categoryId] =
            (categoryTotals[transaction.categoryId] ?? 0) + transaction.amount;
      }
    }
    return categoryTotals;
  }

  List<PieChartSectionData> _generateIncomeCategorySections(
    List<Transaction> transactions,
    List<Category> categories,
  ) {
    final categoryTotals = _calculateIncomeCategoryTotals(transactions);
    final sections = <PieChartSectionData>[];
    final totalIncome = _calculateTotalIncome(transactions);
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Only show top 3 categories, combine the rest into "Others"
    final topCategories = sortedCategories.take(3).toList();
    double othersTotal = 0;

    for (var entry in sortedCategories) {
      if (topCategories.contains(entry)) {
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
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

        final percentage = entry.value / totalIncome * 100;
        sections.add(
          PieChartSectionData(
            color: category.color,
            value: entry.value,
            title: percentage >= 10 ? '${percentage.toStringAsFixed(0)}%' : '',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      } else {
        othersTotal += entry.value;
      }
    }

    // Add "Others" section if there are remaining categories
    if (othersTotal > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: othersTotal,
          title: '',
          radius: 100,
        ),
      );
    }

    return sections;
  }

  Widget _buildSimplifiedIncomeCategoryLegend(
    List<Transaction> transactions,
    List<Category> categories,
  ) {
    final categoryTotals = _calculateIncomeCategoryTotals(transactions);
    final totalIncome = _calculateTotalIncome(transactions);
    final sorted = categoryTotals.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sorted.take(3).map((entry) {
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
          orElse: () => Category(
            id: '',
            name: 'Other',
            type: '',
            color: Colors.grey,
            icon: Icons.category,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: '',
          ),
        );
        final percent = (entry.value / totalIncome * 100).round();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: category.color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(category.name,
                      style: Theme.of(context).textTheme.bodyMedium)),
              Text('$percent%',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
