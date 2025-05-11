import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:expense_tracker/features/category/presentation/widgets/category_form_dialog.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionPage({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _titleController;
  late String _selectedType;
  late String? _selectedCategoryId;
  bool _isSubmitting = false;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  // Add error state variables
  bool _showErrors = false;
  String? _titleError;
  String? _amountError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing transaction data
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _descriptionController =
        TextEditingController(text: widget.transaction.description);
    _titleController =
        TextEditingController(text: widget.transaction.description);
    _selectedType = widget.transaction.type;
    _selectedCategoryId = widget.transaction.categoryId;
    _selectedDate = widget.transaction.date;
    _selectedTime = TimeOfDay.fromDateTime(widget.transaction.date);

    // Load categories when the page is opened
    context.read<CategoryBloc>().add(GetCategoriesByType(_selectedType));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _validateForm() {
    final l10n = AppLocalizations.of(context);
    _titleError = null;
    _amountError = null;
    _categoryError = null;

    if (_titleController.text.isEmpty) {
      _titleError = l10n.get('required_field');
    }

    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null ||
        double.parse(_amountController.text) <= 0) {
      _amountError = l10n.get('invalid_input');
    }

    if (_selectedCategoryId == null) {
      _categoryError = l10n.get('select_category');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoaded) {
          Navigator.pop(context);
        } else if (state is TransactionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          setState(() {
            _isSubmitting = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.get('edit_transaction')),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(l10n.get('delete_transaction')),
                    content: Text(l10n.get('delete_transaction_confirmation')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(l10n.get('cancel')),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.read<TransactionBloc>().add(
                                DeleteTransaction(widget.transaction),
                              );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(l10n.get('delete')),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction Type Selection
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Wrap(
                            spacing: 10,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedType = 'Income';
                                  });
                                  context
                                      .read<CategoryBloc>()
                                      .add(GetCategoriesByType(_selectedType));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedType == 'Income'
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.primary
                                          .withOpacity(0.1),
                                  foregroundColor: _selectedType == 'Income'
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                ),
                                child: Text(l10n.get('income_type')),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedType = 'Expense';
                                  });
                                  context
                                      .read<CategoryBloc>()
                                      .add(GetCategoriesByType(_selectedType));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedType == 'Expense'
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.primary
                                          .withOpacity(0.1),
                                  foregroundColor: _selectedType == 'Expense'
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                ),
                                child: Text(l10n.get('expense_type')),
                              ),
                            ],
                          ),
                        ),

                        // Title Field
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: l10n.get('title'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorText: _showErrors ? _titleError : null,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.get('required_field');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Description Field
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: l10n.get('description'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          maxLines: null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.get('required_field');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Amount Field
                        TextFormField(
                          controller: _amountController,
                          decoration: InputDecoration(
                            labelText: l10n.get('enter_amount'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text('Birr'),
                            ),
                            errorText: _showErrors ? _amountError : null,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.get('required_field');
                            }
                            if (double.tryParse(value) == null) {
                              return l10n.get('invalid_input');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Date and Time Selection
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: theme.dividerColor),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 18,
                                          color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(DateFormat('dd/MM/yyyy')
                                          .format(_selectedDate)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectTime(context),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: theme.dividerColor),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 18,
                                          color: theme.colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(_selectedTime.format(context)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Category Selection
                        Container(
                          padding: const EdgeInsets.only(left: 15, bottom: 15),
                          child: Row(
                            children: [
                              Text(
                                l10n.get('select_category'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (_showErrors && _categoryError != null)
                                Text(
                                  _categoryError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 25,
                            left: 15,
                            right: 15,
                          ),
                          width: double.infinity,
                          child: BlocBuilder<CategoryBloc, CategoryState>(
                            builder: (context, state) {
                              if (state is CategoryLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is CategoryLoaded) {
                                final categories = state.categories;
                                return Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: List.generate(categories.length + 1,
                                      (index) {
                                    if (categories.length == index) {
                                      return ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(minWidth: 0),
                                        child: IntrinsicWidth(
                                          child: MaterialButton(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: const BorderSide(
                                                width: 1.5,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 0,
                                            ),
                                            elevation: 0,
                                            focusElevation: 0,
                                            hoverElevation: 0,
                                            highlightElevation: 0,
                                            disabledElevation: 0,
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const CategoryFormDialog(),
                                              ).then((_) {
                                                // Refresh categories after adding new one
                                                context
                                                    .read<CategoryBloc>()
                                                    .add(GetCategoriesByType(
                                                        _selectedType));
                                              });
                                            },
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: theme
                                                        .colorScheme.primary,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    l10n.get('add_category'),
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final category = categories[index];
                                    return ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(minWidth: 0),
                                      child: IntrinsicWidth(
                                        child: MaterialButton(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                              width: 1.5,
                                              color: _selectedCategoryId ==
                                                      category.id
                                                  ? theme.colorScheme.primary
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 0,
                                          ),
                                          elevation: 0,
                                          focusElevation: 0,
                                          hoverElevation: 0,
                                          highlightElevation: 0,
                                          disabledElevation: 0,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onPressed: () {
                                            setState(() {
                                              _selectedCategoryId = category.id;
                                            });
                                          },
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CategoryFormDialog(
                                                      category: category),
                                            ).then((_) {
                                              // Refresh categories after editing
                                              context.read<CategoryBloc>().add(
                                                  GetCategoriesByType(
                                                      _selectedType));
                                            });
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  category.icon,
                                                  color: category.color,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  category.name,
                                                  style: theme
                                                      .textTheme.bodyMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }
                              return Center(
                                  child: Text(l10n.get('no_categories')));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Save Button
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        setState(() {
                          _showErrors = true;
                        });
                        _validateForm();

                        if (_formKey.currentState!.validate() &&
                            _titleError == null &&
                            _amountError == null &&
                            _categoryError == null) {
                          setState(() {
                            _isSubmitting = true;
                          });
                          final updatedTransaction =
                              widget.transaction.copyWith(
                            amount: double.parse(_amountController.text),
                            description: _descriptionController.text,
                            type: _selectedType,
                            categoryId: _selectedCategoryId!,
                            date: _selectedDate,
                          );
                          context.read<TransactionBloc>().add(
                                UpdateTransaction(updatedTransaction),
                              );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(
                        l10n.get('update_transaction'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
