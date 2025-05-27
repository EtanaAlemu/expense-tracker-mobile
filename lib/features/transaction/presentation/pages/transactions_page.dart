import 'package:expense_tracker/core/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/features/transaction/presentation/pages/edit_transaction_page.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
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
import 'package:intl/intl.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_category.dart'
    as get_category;
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String? _selectedType = null;
  Set<String> _selectedCategoryIds = {};
  late final TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();
    _transactionBloc = TransactionBloc(
      getTransactions: getIt<get_transactions.GetTransactions>(),
      addTransaction: getIt<add_transaction.AddTransaction>(),
      updateTransaction: getIt<update_transaction.UpdateTransaction>(),
      deleteTransaction: getIt<delete_transaction.DeleteTransaction>(),
      syncTransactions: getIt<sync_transactions.SyncTransactions>(),
      authRepository: getIt<AuthRepository>(),
      getCategory: getIt<get_category.GetCategory>(),
      notificationService: getIt<NotificationService>(),
    )..add(GetTransactions());

    context.read<CategoryBloc>().add(GetCategories());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _transactionBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
      }
    } else {
      if (!_showFab) {
        setState(() => _showFab = true);
      }
    }
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _transactionBloc,
          child: EditTransactionPage(transaction: transaction),
        ),
      ),
    ).then((_) {
      // Refresh transactions when returning from edit page
      _transactionBloc.add(GetTransactions());
    });
  }

  void _showFilterSheet(BuildContext context, List<Category> categories) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.clear_all),
                          tooltip: l10n.get('clear_filters'),
                          onPressed: () {
                            setModalState(() {
                              _selectedDateRange = null;
                              _selectedType = null;
                              _selectedCategoryIds.clear();
                            });
                          },
                        ),
                        Text(
                          l10n.get('filters'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          tooltip: l10n.get('apply_filters'),
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(l10n.get('type'), style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children:
                          [l10n.get('income'), l10n.get('expense')].map((type) {
                        final selected = _selectedType == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: selected,
                          onSelected: (isSelected) {
                            setModalState(() {
                              _selectedType = isSelected ? type : null;
                            });
                          },
                          selectedColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.get('categories'),
                        style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categories.map((category) {
                        final selected =
                            _selectedCategoryIds.contains(category.id);
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(category.icon,
                                  color: category.color, size: 18),
                              const SizedBox(width: 6),
                              Text(category.name),
                            ],
                          ),
                          selected: selected,
                          onSelected: (isSelected) {
                            setModalState(() {
                              if (isSelected) {
                                _selectedCategoryIds.add(category.id);
                              } else {
                                _selectedCategoryIds.remove(category.id);
                              }
                            });
                          },
                          selectedColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(_selectedDateRange == null
                          ? l10n.get('date_range')
                          : '${DateFormat('MM/dd').format(_selectedDateRange!.start)} - ${DateFormat('MM/dd').format(_selectedDateRange!.end)}'),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialDateRange: _selectedDateRange,
                        );
                        if (picked != null) {
                          setModalState(() => _selectedDateRange = picked);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _transactionBloc,
      child: Scaffold(
        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, transactionState) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                if (transactionState is TransactionLoading &&
                    !(transactionState is TransactionLoaded)) {
                  return const Center(child: CircularProgressIndicator());
                } else if (transactionState is TransactionError) {
                  return Center(child: Text(transactionState.message));
                } else if (categoryState is CategoryError) {
                  return Center(child: Text(categoryState.error ?? ''));
                } else if (transactionState is TransactionLoaded) {
                  final transactions = transactionState.transactions;
                  final categories = categoryState is CategoryLoaded
                      ? (categoryState.categories ?? []).cast<Category>()
                      : <Category>[];

                  // Advanced filtering
                  List<Transaction> filtered = transactions.where((t) {
                    final matchesSearch = _searchQuery.isEmpty ||
                        t.description
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                    final matchesType =
                        _selectedType == null || t.type == _selectedType;
                    final matchesCategory = _selectedCategoryIds.isEmpty ||
                        _selectedCategoryIds.contains(t.categoryId);
                    final matchesDate = _selectedDateRange == null ||
                        (t.date.isAfter(_selectedDateRange!.start
                                .subtract(const Duration(days: 1))) &&
                            t.date.isBefore(_selectedDateRange!.end
                                .add(const Duration(days: 1))));
                    return matchesSearch &&
                        matchesType &&
                        matchesCategory &&
                        matchesDate;
                  }).toList();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 48.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: l10n.get('search_transactions'),
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 16,
                                  ),
                                ),
                                onChanged: (value) =>
                                    setState(() => _searchQuery = value),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              tooltip: l10n.get('filters'),
                              onPressed: () =>
                                  _showFilterSheet(context, categories),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 64,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.get('no_transactions_found'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.get('add_first_transaction'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(
                                  top: 0.0,
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 16.0,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final transaction = filtered[index];
                                  return TransactionListItem(
                                    transaction: transaction,
                                    onTap: () => _showTransactionDetails(
                                        context, transaction),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: _showFab ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showFab ? 1 : 0,
            child: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: _transactionBloc,
                      child: const AddTransactionPage(),
                    ),
                  ),
                );

                // Refresh transactions if a new transaction was added
                if (result == true) {
                  _transactionBloc.add(GetTransactions());
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
