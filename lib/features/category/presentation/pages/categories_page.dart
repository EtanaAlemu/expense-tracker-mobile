import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:expense_tracker/features/category/presentation/widgets/category_form_dialog.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  String _searchQuery = '';
  Set<String> _selectedTypes = {};

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

  void _showFilterSheet(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Apply and Clear icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.clear_all),
                          tooltip: l10n.get('clear_filters'),
                          onPressed: () {
                            setModalState(() {
                              _selectedTypes.clear();
                            });
                          },
                        ),
                        Text(
                          l10n.get('filters'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          tooltip: l10n.get('apply_filters'),
                          onPressed: () {
                            setState(() {}); // Apply filters to main page
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    // Type Multi-Select
                    Text(l10n.get('type'), style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: [
                        l10n.get('income_type'),
                        l10n.get('expense_type')
                      ].map((type) {
                        final selected = _selectedTypes.contains(type);
                        return FilterChip(
                          label: Text(type),
                          selected: selected,
                          onSelected: (isSelected) {
                            setModalState(() {
                              if (isSelected) {
                                _selectedTypes.add(type);
                              } else {
                                _selectedTypes.remove(type);
                              }
                            });
                          },
                          selectedColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {

        return BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? ''),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          child: Scaffold(
            body: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return Center(child: Text(l10n.get('loading')));
                } else if (state is CategoryLoaded) {
                  // Filtering
                  final filteredCategories = state.categories!.where((cat) {
                    final matchesSearch = _searchQuery.isEmpty ||
                        cat.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                    final matchesType = _selectedTypes.isEmpty ||
                        _selectedTypes.contains(cat.type);
                    return matchesSearch && matchesType;
                  }).toList();
                  return Column(
                    children: [
                      // Search and Filter
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 48.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: l10n.get('search_categories'),
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 16),
                                ),
                                onChanged: (value) =>
                                    setState(() => _searchQuery = value),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              tooltip: l10n.get('filters'),
                              onPressed: () => _showFilterSheet(context),
                            ),
                          ],
                        ),
                      ),
                      // Category List
                      Expanded(
                        child: filteredCategories.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category_outlined,
                                      size: 64,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.get('no_categories_found'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.get('add_first_category'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : _buildCategoryList(context, filteredCategories),
                      ),
                    ],
                  );
                } else if (state is CategoryError) {
                  // Use previous categories if available
                  if (state.previousCategories != null) {
                    // Filtering
                    final filteredCategories =
                        state.previousCategories!.where((cat) {
                      final matchesSearch = _searchQuery.isEmpty ||
                          cat.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                      final matchesType = _selectedTypes.isEmpty ||
                          _selectedTypes.contains(cat.type);
                      return matchesSearch && matchesType;
                    }).toList();
                    return Column(
                      children: [
                        // Search and Filter
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 48.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: l10n.get('search_categories'),
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 16),
                                  ),
                                  onChanged: (value) =>
                                      setState(() => _searchQuery = value),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.filter_list),
                                tooltip: l10n.get('filters'),
                                onPressed: () => _showFilterSheet(context),
                              ),
                            ],
                          ),
                        ),
                        // Category List
                        Expanded(
                          child: filteredCategories.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.category_outlined,
                                        size: 64,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.get('no_categories_found'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.get('add_first_category'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              : _buildCategoryList(context, filteredCategories),
                        ),
                      ],
                    );
                  }
                }
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
          ),
        );
      },
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
          subtitle: Text(category.type == l10n.get('expense_type')
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
