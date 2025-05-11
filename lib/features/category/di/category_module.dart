import 'package:injectable/injectable.dart';
import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/features/category/data/local/category_local_data_source.dart';
import 'package:expense_tracker/features/category/data/mappers/category_mapper.dart';
import 'package:expense_tracker/features/category/data/remote/category_remote_data_source.dart';
import 'package:expense_tracker/features/category/data/remote/category_remote_data_source_impl.dart';
import 'package:expense_tracker/features/category/data/repositories/category_repository_impl.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';
import 'package:expense_tracker/features/category/domain/usecases/add_category.dart';
import 'package:expense_tracker/features/category/domain/usecases/delete_category.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_categories_by_type.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_category.dart';
import 'package:expense_tracker/features/category/domain/usecases/update_category.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

@module
abstract class CategoryModule {
  @singleton
  CategoryMapper categoryMapper() => CategoryMapper();

  @singleton
  CategoryLocalDataSource categoryLocalDataSource() =>
      CategoryLocalDataSource();

  @singleton
  CategoryRemoteDataSource categoryRemoteDataSource(
    ApiService apiService,
    CategoryMapper mapper,
    AppLocalizations l10n,
  ) =>
      CategoryRemoteDataSourceImpl(
        apiService: apiService,
        mapper: mapper,
        l10n: l10n,
      );

  @singleton
  CategoryRepository categoryRepository(
    CategoryLocalDataSource localDataSource,
    CategoryRemoteDataSource remoteDataSource,
    CategoryMapper mapper,
    NetworkInfo networkInfo,
    AppLocalizations l10n,
  ) =>
      CategoryRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
        mapper: mapper,
        networkInfo: networkInfo,
        l10n: l10n,
      );

  @singleton
  AddCategory addCategoryUseCase(CategoryRepository repository) =>
      AddCategory(repository);

  @singleton
  GetCategories getCategories(CategoryRepository repository) =>
      GetCategories(repository);

  @singleton
  GetCategory getCategory(CategoryRepository repository) =>
      GetCategory(repository);

  @singleton
  UpdateCategory updateCategory(CategoryRepository repository) =>
      UpdateCategory(repository);

  @singleton
  DeleteCategory deleteCategory(CategoryRepository repository) =>
      DeleteCategory(repository);

  @singleton
  GetCategoriesByType getCategoriesByType(CategoryRepository repository) =>
      GetCategoriesByType(repository);

  @injectable
  CategoryBloc categoryBloc(
    GetCategories getCategories,
    GetCategory getCategory,
    AddCategory addCategory,
    UpdateCategory updateCategory,
    DeleteCategory deleteCategory,
    GetCategoriesByType getCategoriesByType,
    CategoryRepository repository,
    AppLocalizations l10n,
  ) =>
      CategoryBloc(
        getCategories: getCategories,
        getCategory: getCategory,
        addCategory: addCategory,
        updateCategory: updateCategory,
        deleteCategory: deleteCategory,
        getCategoriesByType: getCategoriesByType,
        repository: repository,
        l10n: l10n,
      );
}
