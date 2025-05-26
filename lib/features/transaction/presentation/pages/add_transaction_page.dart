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
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/services/notification/notification_service.dart';
import 'package:expense_tracker/injection/injection.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

  // Add focus nodes for each field
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();

  String _selectedType = 'Expense';
  String? _selectedCategoryId;
  bool _isSubmitting = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Add error state variables
  bool _showErrors = false;
  String? _titleError;
  String? _amountError;
  String? _categoryError;

  late final NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = getIt<NotificationService>();
    // Load categories when the page is opened
    context.read<CategoryBloc>().add(GetCategoriesByType(_selectedType));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    // Dispose focus nodes
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now()
          .add(const Duration(days: 365)), // Allow dates up to 1 year in future
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

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryInitial) {
          // Load categories when the page is opened
          context.read<CategoryBloc>().add(GetCategoriesByType(_selectedType));
        }
      },
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionLoaded) {
            if (mounted && Navigator.canPop(context)) {
              Navigator.pop(context, true);
            }
          } else if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            if (_isSubmitting) {
              return false;
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.get('add_transaction')),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _isSubmitting
                    ? null
                    : () {
                        if (mounted && Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
              ),
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
                                      context.read<CategoryBloc>().add(
                                          GetCategoriesByType(_selectedType));
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
                                      context.read<CategoryBloc>().add(
                                          GetCategoriesByType(_selectedType));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _selectedType == 'Expense'
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.primary
                                                  .withOpacity(0.1),
                                      foregroundColor:
                                          _selectedType == 'Expense'
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
                              focusNode: _titleFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                _titleFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_descriptionFocusNode);
                              },
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
                              focusNode: _descriptionFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                _descriptionFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_amountFocusNode);
                              },
                              decoration: InputDecoration(
                                labelText: l10n.get('description'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              maxLines: null,
                            ),
                            const SizedBox(height: 16),

                            // Amount Field
                            TextFormField(
                              controller: _amountController,
                              focusNode: _amountFocusNode,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                _amountFocusNode.unfocus();
                              },
                              decoration: InputDecoration(
                                labelText: l10n.get('enter_amount'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    final currency =
                                        state.user?.currency ?? 'Br';
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        _getCurrencySymbol(currency),
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    );
                                  },
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
                                        border: Border.all(
                                            color: theme.dividerColor),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 18,
                                              color: _selectedDate
                                                      .isAfter(DateTime.now())
                                                  ? Colors.orange
                                                  : theme.colorScheme.primary),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(_selectedDate),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (_selectedDate
                                                    .isAfter(DateTime.now()))
                                                  Text(
                                                    '(Upcoming)',
                                                    style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
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
                                        border: Border.all(
                                            color: theme.dividerColor),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.access_time,
                                              size: 18,
                                              color: _selectedDate
                                                      .isAfter(DateTime.now())
                                                  ? Colors.orange
                                                  : theme.colorScheme.primary),
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
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 15),
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
                                    final categories = state.categories!;
                                    return Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: List.generate(
                                          categories.length + 1, (index) {
                                        if (categories.length == index) {
                                          return ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth: 0),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                        .add(
                                                            GetCategoriesByType(
                                                                _selectedType));
                                                  });
                                                },
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        color: theme.colorScheme
                                                            .primary,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        l10n.get(
                                                            'add_category'),
                                                        style: theme.textTheme
                                                            .bodyMedium,
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
                                                      ? theme
                                                          .colorScheme.primary
                                                      : Colors.transparent,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 0,
                                              ),
                                              elevation: 0,
                                              focusElevation: 0,
                                              hoverElevation: 0,
                                              highlightElevation: 0,
                                              disabledElevation: 0,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              onPressed: () {
                                                setState(() {
                                                  _selectedCategoryId =
                                                      category.id;
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
                              _submitForm();
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
                            l10n.get('save'),
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
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'ETB':
        return 'Br';
      default:
        return 'Br';
    }
  }

  // Add a method to handle form submission
  void _submitForm() {
    setState(() {
      _isSubmitting = true;
    });
    final userId = context.read<AuthBloc>().state.user?.id ?? '';
    final transaction = Transaction(
      id: '',
      userId: userId,
      amount: double.parse(_amountController.text),
      title: _titleController.text,
      description: _descriptionController.text,
      type: _selectedType,
      categoryId: _selectedCategoryId!,
      date: _selectedDate,
    );

    // Schedule notification if it's an upcoming transaction
    if (_selectedDate.isAfter(DateTime.now())) {
      _notificationService.scheduleTransactionNotification(transaction);
    }

    context.read<TransactionBloc>().add(
          AddTransaction(transaction),
        );
  }
}
