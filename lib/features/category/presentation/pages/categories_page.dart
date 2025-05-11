import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:expense_tracker/features/category/presentation/widgets/category_form_dialog.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategories());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
      }
    } else {
      if (!_showFab) {
        setState(() => _showFab = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          print('🔄 CategoriesPage state: $state');
          if (state is CategoryLoading) {
            return Center(child: Text(l10n.get('loading')));
          } else if (state is CategoryLoaded) {
            print(
                '📦 CategoriesPage loaded ${state.categories.length} categories');
            return Column(
              children: [
                // Category List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: _buildCategoryList(context, state.categories),
                  ),
                ),
              ],
            );
          } else if (state is CategoryError) {
            print('❌ CategoriesPage error: ${state.message}');
            return Center(child: Text(state.message));
          }
          print('ℹ️ CategoriesPage initial state');
          return Center(child: Text(l10n.get('no_data')));
        },
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CategoryFormDialog(),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories) {
    final l10n = AppLocalizations.of(context);
    return ListView.builder(
      controller: _scrollController,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: category.color,
            child: Icon(
              category.icon,
              color: Colors.white,
            ),
          ),
          title: Text(category.name),
          subtitle: Text(category.type == 'Expense'
              ? l10n.get('expense_type')
              : l10n.get('income_type')),
          onTap: category.isDefault
              ? null
              : () => _showEditCategoryDialog(context, category),
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => CategoryFormDialog(category: category),
    );
  }
}
