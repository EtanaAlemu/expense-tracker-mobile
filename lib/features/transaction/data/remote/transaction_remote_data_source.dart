import 'package:expense_tracker/core/constants/api_constants.dart';
import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';

class TransactionRemoteDataSource {
  final ApiService _apiService;
  final TransactionMapper _mapper;

  TransactionRemoteDataSource({
    required ApiService apiService,
    required TransactionMapper mapper,
  })  : _apiService = apiService,
        _mapper = mapper;

  Future<List<Transaction>> getTransactions() async {
    final response = await _apiService.dio.get(ApiConstants.transactions);
    final List<dynamic> data = response.data;
    return data.map((json) => _mapper.toEntity(json)).toList();
  }

  Future<List<Transaction>> getTransactionsByType(String type) async {
    final response = await _apiService.dio.get(
      ApiConstants.transactions,
      queryParameters: {'type': type},
    );
    final List<dynamic> data = response.data;
    return data.map((json) => _mapper.toEntity(json)).toList();
  }

  Future<List<Transaction>> getTransactionsByCategory(String categoryId) async {
    final response = await _apiService.dio.get(
      ApiConstants.transactions,
      queryParameters: {'category': categoryId},
    );
    final List<dynamic> data = response.data;
    return data.map((json) => _mapper.toEntity(json)).toList();
  }

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await _apiService.dio.get(
      ApiConstants.transactions,
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );
    final List<dynamic> data = response.data;
    return data.map((json) => _mapper.toEntity(json)).toList();
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    final json = _mapper.toJson(transaction);
    final response = await _apiService.dio.post(
      ApiConstants.transactions,
      data: json,
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to save transaction');
    }
    return _mapper.toEntity(response.data);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final json = _mapper.toJson(transaction);
    await _apiService.dio.put(
      '${ApiConstants.transactions}/${transaction.id}',
      data: json,
    );
  }

  Future<void> deleteTransaction(String id) async {
    await _apiService.dio.delete(
      '${ApiConstants.transactions}/$id',
    );
  }
}
