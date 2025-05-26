import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/core/constants/api_constants.dart';
import 'package:expense_tracker/features/category/data/mappers/category_mapper.dart';
import 'package:expense_tracker/features/category/data/remote/category_remote_data_source.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:flutter/material.dart' show debugPrint;

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService _apiService;
  final CategoryMapper _mapper;

  CategoryRemoteDataSourceImpl({
    required ApiService apiService,
    required CategoryMapper mapper,
  })  : _apiService = apiService,
        _mapper = mapper;

  @override
  Future<Category> addCategory(Category category) async {
    debugPrint('📤 Sending category to server: ${category.name}');
    final response = await _apiService.dio.post(
      ApiConstants.categories,
      data: _mapper.toApiModel(category),
    );
    debugPrint('📥 Server response: ${response.data}');

    if (response.statusCode != 201) {
      debugPrint('❌ Server error: ${response.statusCode} - ${response.data}');
      throw Exception('Failed to save category');
    }

    final responseData = response.data;
    if (responseData == null || responseData['success'] != true) {
      debugPrint('❌ Invalid server response: success is false or missing');
      throw Exception('Invalid server response: operation failed');
    }

    final categoryData = responseData['data'];
    if (categoryData == null || categoryData['_id'] == null) {
      debugPrint('❌ Invalid server response: missing category data or _id');
      throw Exception('Invalid server response: missing category ID');
    }

    debugPrint('✅ Category created with ID: ${categoryData['_id']}');
    return _mapper.toEntity(categoryData);
  }

  @override
  Future<Category?> getCategory(String id) async {
    final response =
        await _apiService.dio.get('${ApiConstants.categories}/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to get category');
    }
    return _mapper.toEntity(response.data);
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await _apiService.dio.get(ApiConstants.categories);
    if (response.statusCode != 200) {
      throw Exception('Failed to get categories');
    }
    return (response.data as List).map((json) {
      return _mapper.toEntity(json);
    }).toList();
  }

  @override
  Future<void> updateCategory(Category category) async {
    final response = await _apiService.dio.put(
      '${ApiConstants.categories}/${category.id}',
      data: _mapper.toApiModel(category),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    if (id.isEmpty) {
      throw Exception('Category id required');
    }
    final response =
        await _apiService.dio.delete('${ApiConstants.categories}/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

  @override
  Future<List<Category>> getCategoriesByType(String type) async {
    try {
      final response = await _apiService.dio.get(
        ApiConstants.categories,
        queryParameters: {'type': type},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => _mapper.toEntity(json)).toList();
    } catch (e) {
      throw Exception('Failed to get categories by type: $e');
    }
  }
}
