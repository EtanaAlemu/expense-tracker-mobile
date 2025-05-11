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

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    // Load transactions when the page is opened
    context.read<TransactionBloc>().add(GetTransactions());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
          value: getIt<TransactionBloc>(),
          child: EditTransactionPage(transaction: transaction),
        ),
      ),
    ).then((_) {
      // Refresh the transaction list when returning from EditTransactionPage
      context.read<TransactionBloc>().add(GetTransactions());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          } else if (state is TransactionLoaded) {
            final transactions = state.transactions;

            if (transactions.isEmpty) {
              final theme = Theme.of(context);

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.get('no_transactions'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.get('add_first_transaction'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                  top: 48.0, left: 16.0, right: 16.0, bottom: 16.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionListItem(
                  transaction: transaction,
                  onTap: () => _showTransactionDetails(
                    context,
                    transaction,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: getIt<TransactionBloc>(),
                    child: const AddTransactionPage(),
                  ),
                ),
              ).then((_) {
                // Refresh the transaction list when returning from AddTransactionPage
                context.read<TransactionBloc>().add(GetTransactions());
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
