import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:injectable/injectable.dart';
import 'package:expense_tracker/features/transaction/data/local/transaction_local_data_source.dart';
import 'package:expense_tracker/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:expense_tracker/features/transaction/data/remote/transaction_remote_data_source.dart';
import 'package:expense_tracker/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions_by_type.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/update_transaction.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions_by_date_range.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions_by_category.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_total_transactions_by_category.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart';

@module
abstract class TransactionModule {
  @singleton
  TransactionMapper transactionMapper() => TransactionMapper();

  @singleton
  TransactionLocalDataSource transactionLocalDataSource() =>
      TransactionLocalDataSource();

  @singleton
  TransactionRemoteDataSource transactionRemoteDataSource(
    ApiService apiService,
    TransactionMapper mapper,
  ) =>
      TransactionRemoteDataSource(
        apiService: apiService,
        mapper: mapper,
      );

  @singleton
  TransactionRepository transactionRepository(
    TransactionLocalDataSource localDataSource,
    TransactionRemoteDataSource remoteDataSource,
    TransactionMapper mapper,
    NetworkInfo networkInfo,
  ) =>
      TransactionRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
        mapper: mapper,
        networkInfo: networkInfo,
      );

  @singleton
  AddTransaction addTransaction(TransactionRepository repository) =>
      AddTransaction(repository);

  @singleton
  GetTransactions getTransactions(TransactionRepository repository) =>
      GetTransactions(repository);

  @singleton
  GetTransactionsByType getTransactionsByType(
    TransactionRepository repository,
  ) =>
      GetTransactionsByType(repository);

  @singleton
  UpdateTransaction updateTransaction(TransactionRepository repository) =>
      UpdateTransaction(repository);

  @singleton
  DeleteTransaction deleteTransaction(TransactionRepository repository) =>
      DeleteTransaction(repository);

  @singleton
  GetTransactionsByDateRange getTransactionsByDateRange(
    TransactionRepository repository,
  ) =>
      GetTransactionsByDateRange(repository);

  @singleton
  GetTransactionsByCategory getTransactionsByCategory(
    TransactionRepository repository,
  ) =>
      GetTransactionsByCategory(repository);

  @singleton
  GetTotalTransactionsByCategory getTotalTransactionsByCategory(
    TransactionRepository repository,
  ) =>
      GetTotalTransactionsByCategory(repository);

  @singleton
  TransactionBloc transactionBloc(
    GetTransactions getTransactions,
    AddTransaction addTransaction,
    UpdateTransaction updateTransaction,
    DeleteTransaction deleteTransaction,
  ) =>
      TransactionBloc(
        getTransactions: getTransactions,
        addTransaction: addTransaction,
        updateTransaction: updateTransaction,
        deleteTransaction: deleteTransaction,
      );
}
