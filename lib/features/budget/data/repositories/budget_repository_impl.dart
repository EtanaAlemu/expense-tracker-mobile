import 'package:expense_tracker/features/budget/data/local/budget_local_data_source.dart';
import 'package:expense_tracker/features/budget/data/mappers/budget_mapper.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource _localDataSource;
  final BudgetMapper _mapper;

  BudgetRepositoryImpl({
    required BudgetLocalDataSource localDataSource,
    required BudgetMapper mapper,
  }) : _localDataSource = localDataSource,
       _mapper = mapper;

  @override
  Future<void> save(Budget budget) async {
    final hiveModel = _mapper.toHiveModel(budget);
    await _localDataSource.save(hiveModel);
  }

  @override
  Future<void> saveAll(List<Budget> budgets) async {
    final hiveModels = budgets.map(_mapper.toHiveModel).toList();
    await _localDataSource.saveAll(hiveModels);
  }

  @override
  Future<Budget?> get(String id) async {
    final hiveModel = await _localDataSource.get(id);
    return hiveModel != null ? _mapper.toEntity(hiveModel) : null;
  }

  @override
  Future<List<Budget>> getAll() async {
    final hiveModels = await _localDataSource.getAll();
    return hiveModels.map(_mapper.toEntity).toList();
  }

  @override
  Future<void> update(Budget budget) async {
    final hiveModel = _mapper.toHiveModel(budget);
    await _localDataSource.update(hiveModel);
  }

  @override
  Future<void> delete(Budget budget) async {
    final hiveModel = _mapper.toHiveModel(budget);
    await _localDataSource.delete(hiveModel);
  }

  @override
  Future<void> clear() async {
    await _localDataSource.clear();
  }

  @override
  Future<List<Budget>> getBudgetsByCategory(String categoryId) async {
    final allBudgets = await getAll();
    return allBudgets
        .where((budget) => budget.categoryId == categoryId)
        .toList();
  }

  @override
  Future<List<Budget>> getActiveBudgets() async {
    final allBudgets = await getAll();
    return allBudgets.where((budget) => budget.isActive).toList();
  }

  @override
  Future<List<Budget>> getBudgetsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allBudgets = await getAll();
    return allBudgets
        .where(
          (budget) =>
              budget.startDate.isAfter(startDate) &&
              budget.endDate.isBefore(endDate),
        )
        .toList();
  }

  @override
  Future<double> getTotalBudgetByCategory(String categoryId) async {
    final budgets = await getBudgetsByCategory(categoryId);
    return budgets.fold<double>(0.0, (sum, budget) => sum + budget.limit);
  }
}
