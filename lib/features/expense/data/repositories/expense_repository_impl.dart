import 'package:expense_tracker/features/expense/data/local/expense_local_data_source.dart';
import 'package:expense_tracker/features/expense/data/mappers/expense_mapper.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource _localDataSource;
  final ExpenseMapper _mapper;

  ExpenseRepositoryImpl({
    required ExpenseLocalDataSource localDataSource,
    required ExpenseMapper mapper,
  }) : _localDataSource = localDataSource,
       _mapper = mapper;

  @override
  Future<void> save(Expense expense) async {
    final hiveModel = _mapper.toHiveModel(expense);
    await _localDataSource.save(hiveModel);
  }

  @override
  Future<void> saveAll(List<Expense> expenses) async {
    final hiveModels = expenses.map(_mapper.toHiveModel).toList();
    await _localDataSource.saveAll(hiveModels);
  }

  @override
  Future<Expense?> get(String id) async {
    final hiveModel = await _localDataSource.get(id);
    return hiveModel != null ? _mapper.toEntity(hiveModel) : null;
  }

  @override
  Future<List<Expense>> getAll() async {
    final hiveModels = await _localDataSource.getAll();
    return hiveModels.map(_mapper.toEntity).toList();
  }

  @override
  Future<void> update(Expense expense) async {
    final hiveModel = _mapper.toHiveModel(expense);
    await _localDataSource.update(hiveModel);
  }

  @override
  Future<void> delete(Expense expense) async {
    final hiveModel = _mapper.toHiveModel(expense);
    await _localDataSource.delete(hiveModel);
  }

  @override
  Future<void> clear() async {
    await _localDataSource.clear();
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) async {
    final allExpenses = await getAll();
    return allExpenses
        .where((expense) => expense.categoryId == categoryId)
        .toList();
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allExpenses = await getAll();
    return allExpenses
        .where(
          (expense) =>
              expense.date.isAfter(startDate) && expense.date.isBefore(endDate),
        )
        .toList();
  }

  @override
  Future<double> getTotalExpensesByCategory(String categoryId) async {
    final expenses = await getExpensesByCategory(categoryId);
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  Future<double> getTotalExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final expenses = await getExpensesByDateRange(startDate, endDate);
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }
}
