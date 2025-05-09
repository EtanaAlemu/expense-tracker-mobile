import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return _buildCategoryList(context, state.categories);
          } else if (state is CategoryError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No categories found'));
        },
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        print(
            'Category: ${category.name}, isDefault: ${category.isDefault}'); // Debug log

        final trailing = category.isDefault
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditCategoryDialog(context, category),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteConfirmation(context, category),
                  ),
                ],
              );

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(category.color ?? 0xFF000000),
            child: Icon(
              IconData(int.parse(category.icon ?? '0'),
                  fontFamily: 'MaterialIcons'),
              color: Colors.white,
            ),
          ),
          title: Text(category.name),
          subtitle: Text(category.type),
          trailing: trailing,
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    int selectedColor = Colors.blue.value;
    int selectedIcon = Icons.category.codePoint;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a type' : null,
              ),
              const SizedBox(height: 16),
              // TODO: Add color picker and icon picker
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
              if (formKey.currentState?.validate() ?? false) {
                final category = Category(
                  id: '',
                  name: nameController.text,
                  type: typeController.text,
                  color: selectedColor,
                  icon: selectedIcon.toString(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  userId: '',
                );
                context.read<CategoryBloc>().add(AddCategory(category));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: category.name);
    final typeController = TextEditingController(text: category.type);
    int selectedColor = Colors.blue.value;
    int selectedIcon = Icons.category.codePoint;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a type' : null,
              ),
              const SizedBox(height: 16),
              // TODO: Add color picker and icon picker
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
              if (formKey.currentState?.validate() ?? false) {
                final updatedCategory = Category(
                  id: category.id,
                  name: nameController.text,
                  type: typeController.text,
                  color: selectedColor,
                  icon: selectedIcon.toString(),
                  createdAt: category.createdAt,
                  updatedAt: DateTime.now(),
                  userId: '',
                );
                context
                    .read<CategoryBloc>()
                    .add(UpdateCategory(updatedCategory));
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete ${category.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<CategoryBloc>()
                  .add(DeleteCategory(category));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
