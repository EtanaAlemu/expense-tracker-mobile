import 'package:expense_tracker/core/data/local/hive_local_data_source.dart';
import 'package:expense_tracker/features/category/data/models/hive_category_model.dart';

class CategoryLocalDataSource extends HiveLocalDataSource<HiveCategoryModel> {
  CategoryLocalDataSource() : super('categories');

  @override
  String getId(HiveCategoryModel item) => item.id ?? '';
}
