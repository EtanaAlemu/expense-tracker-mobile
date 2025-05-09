import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_event.dart'
    as events;
import 'package:expense_tracker/features/transaction/presentation/pages/transaction_list_page.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart'
    as get_transactions;
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart'
    as add_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/update_transaction.dart'
    as update_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/delete_transaction.dart'
    as delete_transaction;

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(
        getTransactions: getIt<get_transactions.GetTransactions>(),
        addTransaction: getIt<add_transaction.AddTransaction>(),
        updateTransaction: getIt<update_transaction.UpdateTransaction>(),
        deleteTransaction: getIt<delete_transaction.DeleteTransaction>(),
      )..add(events.GetTransactions()),
      child: const TransactionListPage(),
    );
  }
}
