import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/core/theme/app_icons.dart';
import 'package:expense_tracker/shared/widgets/app_button.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:intl/intl.dart';

class CategoryFormDialog extends StatefulWidget {
  final Category? category;

  const CategoryFormDialog({super.key, this.category});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  late final TextEditingController _descriptionController;
  late Color _selectedColor;
  late IconData _selectedIcon;
  late String _selectedType;
  late String _selectedTransactionType;
  late String _selectedFrequency;
  late bool _isActive;
  late TextEditingController _defaultAmountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _budgetController = TextEditingController(
      text: widget.category?.budget?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
    _selectedColor = widget.category?.color ?? Colors.blue;
    _selectedIcon = widget.category?.icon ?? AppIcons.getRandomIcon();
    _selectedType = widget.category?.type ?? 'Expense';
    _selectedTransactionType = widget.category?.transactionType ?? 'one-time';
    _selectedFrequency = widget.category?.frequency ?? 'monthly';
    _isActive = widget.category?.isActive ?? true;
    _defaultAmountController = TextEditingController(
      text: widget.category?.defaultAmount?.toString() ?? '',
    );

    // If editing and type is Expense, ensure budget is shown
    if (widget.category != null && widget.category?.type == 'Expense') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedType = 'Expense';
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    _defaultAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return AlertDialog(
          scrollable: true,
          insetPadding: const EdgeInsets.all(10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing
                    ? l10n.get('edit_category')
                    : l10n.get('add_category'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              if (isEditing && !widget.category!.isDefault)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.get('delete_category')),
                        content: Text(l10n
                            .get('delete_category_confirmation')
                            .replaceAll('{name}', widget.category!.name)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.get('cancel')),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<CategoryBloc>()
                                  .add(DeleteCategory(widget.category!));
                              Navigator.pop(context);
                            },
                            child: Text(l10n.get('delete')),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Icon(_selectedIcon, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: l10n.get('category_name'),
                            hintText: l10n.get('enter_category_name'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 15,
                            ),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? l10n.get('category_name_required')
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'Income';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'Income'
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                            foregroundColor: _selectedType == 'Income'
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                            ),
                          ),
                          child: Text(l10n.get('income_type')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'Expense';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'Expense'
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                            foregroundColor: _selectedType == 'Expense'
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                            ),
                          ),
                          child: Text(l10n.get('expense_type')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedTransactionType = 'one-time';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _selectedTransactionType == 'one-time'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                            foregroundColor:
                                _selectedTransactionType == 'one-time'
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                            ),
                          ),
                          child: Text(l10n.get('one_time')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedTransactionType = 'recurring';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _selectedTransactionType == 'recurring'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                            foregroundColor:
                                _selectedTransactionType == 'recurring'
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                            ),
                          ),
                          child: Text(l10n.get('recurring')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_selectedType == 'Expense') ...[
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final currencyCode = state.user?.currency ?? 'BIRR';
                          final currencySymbol =
                              _getCurrencySymbol(currencyCode);

                          return TextFormField(
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,4}')),
                            ],
                            decoration: InputDecoration(
                              labelText: l10n.get('budget'),
                              hintText: l10n.get('enter_budget'),
                              suffixText: currencySymbol,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 15,
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final budget = double.tryParse(value);
                                if (budget == null || budget <= 0) {
                                  return l10n.get('invalid_budget');
                                }
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.get('description'),
                        hintText: l10n.get('enter_description'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Colors.primaries.length,
                      itemBuilder: (BuildContext context, index) => Container(
                        width: 45,
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.5,
                          vertical: 2.5,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = Colors.primaries[index];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.primaries[index],
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                width: 2,
                                color: _selectedColor.value ==
                                        Colors.primaries[index].value
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppIcons.allIcons.length,
                      itemBuilder: (BuildContext context, index) => Container(
                        width: 45,
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.5,
                          vertical: 2.5,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon = AppIcons.allIcons[index];
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: _selectedIcon == AppIcons.allIcons[index]
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              AppIcons.allIcons[index],
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedTransactionType == 'recurring') ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButtonFormField<String>(
                        value: _selectedFrequency,
                        decoration: InputDecoration(
                          labelText: l10n.get('frequency'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 15,
                          ),
                        ),
                        items: [
                          'daily',
                          'weekly',
                          'monthly',
                          'quarterly',
                          'yearly'
                        ].map((frequency) {
                          return DropdownMenuItem(
                            value: frequency,
                            child: Text(l10n.get(frequency)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value!;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _defaultAmountController,
                        decoration: InputDecoration(
                          labelText: l10n.get('default_amount'),
                          hintText: l10n.get('enter_default_amount'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 15,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_selectedTransactionType == 'recurring' &&
                              (value == null || value.isEmpty)) {
                            return l10n.get('default_amount_required');
                          }
                          return null;
                        },
                      ),
                    ),
                    SwitchListTile(
                      title: Text(l10n.get('active')),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: AppButton(
                isFullWidth: false,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final category = Category(
                      id: widget.category?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      type: _selectedType,
                      color: _selectedColor,
                      icon: _selectedIcon,
                      budget: double.tryParse(_budgetController.text),
                      description: _descriptionController.text.isEmpty
                          ? null
                          : _descriptionController.text,
                      createdAt: widget.category?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                      userId: authState.user?.id ?? '',
                      isDefault: widget.category?.isDefault ?? false,
                      isSynced: widget.category?.isSynced ?? false,
                      transactionType: _selectedTransactionType,
                      frequency: _selectedTransactionType == 'recurring'
                          ? _selectedFrequency
                          : null,
                      defaultAmount: _selectedTransactionType == 'recurring'
                          ? double.tryParse(_defaultAmountController.text)
                          : null,
                      isActive: _isActive,
                      lastProcessedDate: widget.category?.lastProcessedDate,
                      nextProcessedDate: widget.category?.nextProcessedDate,
                    );

                    if (isEditing) {
                      context
                          .read<CategoryBloc>()
                          .add(UpdateCategory(category));
                    } else {
                      context.read<CategoryBloc>().add(AddCategory(category));
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(l10n.get('save')),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'BIRR':
        return 'Br';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'INR':
        return '₹';
      case 'CNY':
        return '¥';
      default:
        return 'Br';
    }
  }
}
