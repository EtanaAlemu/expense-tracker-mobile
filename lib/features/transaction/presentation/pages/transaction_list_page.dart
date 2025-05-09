import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  void initState() {
    super.initState();
    // Load transactions when the page is opened
    context.read<TransactionBloc>().add(GetTransactions());
  }

  void _showDeleteConfirmation(
      BuildContext context, Transaction transaction, TransactionBloc bloc) {
    print(
        'Delete confirmation - Transaction: ${transaction.description}, id: ${transaction.id}');
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print(
                  'Deleting transaction - Description: ${transaction.description}, id: ${transaction.id}');
              bloc.add(DeleteTransaction(transaction));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditTransactionDialog(
      BuildContext context, Transaction transaction, TransactionBloc bloc) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditTransactionDialog(
        transaction: transaction,
        bloc: bloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          print('🔄 Building TransactionListPage with state: $state');

          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          } else if (state is TransactionLoaded) {
            final transactions = state.transactions;
            print('📝 Displaying ${transactions.length} transactions');

            if (transactions.isEmpty) {
              return const Center(
                child: Text('No transactions yet. Add your first transaction!'),
              );
            }

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                print(
                    '📋 Building transaction item: ${transaction.description} (${transaction.id})');

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: transaction.type == 'income'
                        ? Colors.green
                        : Colors.red,
                    child: Icon(
                      transaction.type == 'income'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(transaction.description.isEmpty
                      ? 'No description'
                      : transaction.description),
                  subtitle: Text(transaction.categoryId.isEmpty
                      ? 'Uncategorized'
                      : transaction.categoryId),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${transaction.type == 'income' ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction.type == 'income'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditTransactionDialog(
                          context,
                          transaction,
                          context.read<TransactionBloc>(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(
                          context,
                          transaction,
                          context.read<TransactionBloc>(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}

class EditTransactionDialog extends StatefulWidget {
  final Transaction transaction;
  final TransactionBloc bloc;

  const EditTransactionDialog({
    super.key,
    required this.transaction,
    required this.bloc,
  });

  @override
  State<EditTransactionDialog> createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late String selectedType;
  late String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    descriptionController =
        TextEditingController(text: widget.transaction.description);
    selectedType = widget.transaction.type;
    selectedCategoryId = widget.transaction.categoryId;
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Expense',
                  child: Text('Expense'),
                ),
                DropdownMenuItem(
                  value: 'Income',
                  child: Text('Income'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (amountController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty) {
              final updatedTransaction = widget.transaction.copyWith(
                amount: double.parse(amountController.text),
                description: descriptionController.text,
                type: selectedType,
                categoryId: selectedCategoryId ?? '',
              );
              widget.bloc.add(UpdateTransaction(updatedTransaction));
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
