import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/shared/widgets/confirm_dialog.dart';
import 'package:expense_tracker/core/theme/appearance_dialog.dart';
import 'package:expense_tracker/core/theme/currency_dialog.dart';
import 'package:expense_tracker/core/theme/language_dialog.dart';
import 'package:expense_tracker/features/auth/presentation/widgets/change_password_dialog.dart';
import 'package:expense_tracker/features/auth/presentation/widgets/edit_profile_dialog.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/features/main/data/services/export_service.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart'
    as app_category;
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart'
    as category_usecase;
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart' as base;
import 'package:expense_tracker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:expense_tracker/core/usecase/usecase.dart' as usecase;

class ProfilePage extends StatefulWidget {
  final AddTransaction addTransaction;
  final GetTransactions getTransactions;
  final category_usecase.GetCategories getCategories;
  final GetCurrentUserUseCase getCurrentUser;

  const ProfilePage({
    super.key,
    required this.addTransaction,
    required this.getTransactions,
    required this.getCategories,
    required this.getCurrentUser,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _localImageFile;
  List<Transaction> _transactions = [];
  List<app_category.Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (!mounted) return;
      setState(() => _isLoading = true);

      // Get current user
      final userResult = await widget.getCurrentUser(usecase.NoParams());
      final user = userResult.fold(
        (failure) => throw Exception('Failed to get current user: $failure'),
        (user) => user,
      );

      // Get transactions
      final transactionsResult =
          await widget.getTransactions(base.UserParams(userId: user.id));
      final transactions = transactionsResult.fold(
        (failure) => throw Exception('Failed to get transactions: $failure'),
        (transactions) => transactions,
      );

      // Get categories
      final categoriesResult =
          await widget.getCategories(base.UserParams(userId: user.id));
      final categories = categoriesResult.fold(
        (failure) => throw Exception('Failed to get categories: $failure'),
        (categories) => categories,
      );

      if (!mounted) return;
      setState(() {
        _transactions = transactions;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _updateLocalImage(File? imageFile) {
    setState(() {
      _localImageFile = imageFile;
    });
  }

  Widget _buildProfileImage(
      String? imageUrl, String? firstName, ThemeData theme) {
    if (_localImageFile != null) {
      return Image.file(
        _localImageFile!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl == null) {
      return Center(
        child: Text(
          firstName?.substring(0, 1).toUpperCase() ?? 'U',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (imageUrl.startsWith('data:image')) {
      // Handle base64 image
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading base64 image: $error');
            return Center(
              child: Text(
                firstName?.substring(0, 1).toUpperCase() ?? 'U',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
        return Center(
          child: Text(
            firstName?.substring(0, 1).toUpperCase() ?? 'U',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    } else {
      // Handle network image
      return Image.network(
        imageUrl,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading network image: $error');
          return Center(
            child: Text(
              firstName?.substring(0, 1).toUpperCase() ?? 'U',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.white,
            ),
          );
        },
      );
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: l10n.get('logout'),
        message: l10n.get('logout_confirmation'),
        confirmLabel: l10n.get('logout'),
        cancelLabel: l10n.get('cancel'),
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const SignOutEvent());
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AppearanceDialog(),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CurrencyDialog(),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguageDialog(),
    );
  }

  void _showExportDialog(BuildContext context, List<Transaction> transactions) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final exportService = ExportService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.get('export_data')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  Icon(Icons.table_chart, color: theme.colorScheme.primary),
              title: Text(l10n.get('export_as_csv')),
              onTap: () async {
                Navigator.pop(context);
                if (transactions.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('no_transactions')),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                  return;
                }
                try {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.get('preparing_export'))),
                  );
                  await exportService.exportToCSV();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('export_completed')),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  _handleExportError(context, e);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.table_view, color: theme.colorScheme.primary),
              title: Text(l10n.get('export_as_excel')),
              onTap: () async {
                Navigator.pop(context);
                if (transactions.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('no_transactions')),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                  return;
                }
                try {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.get('preparing_export'))),
                  );
                  await exportService.exportToExcel();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('export_completed')),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  _handleExportError(context, e);
                }
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
              title: Text(l10n.get('export_as_pdf')),
              onTap: () async {
                Navigator.pop(context);
                if (transactions.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('no_transactions')),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                  return;
                }
                try {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.get('preparing_export'))),
                  );
                  await exportService.exportToPDF();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.get('export_completed')),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  _handleExportError(context, e);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.get('cancel')),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.get('import_data')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  Icon(Icons.upload_file, color: theme.colorScheme.primary),
              title: Text(l10n.get('import_from_csv')),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await _handleImport('CSV');
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n
                            .get('error_importing_csv')
                            .replaceAll('{error}', e.toString())),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.upload_file, color: theme.colorScheme.primary),
              title: Text(l10n.get('import_from_excel')),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await _handleImport('Excel');
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n
                            .get('error_importing_excel')
                            .replaceAll('{error}', e.toString())),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.get('cancel')),
          ),
        ],
      ),
    );
  }

  void _handleExportError(BuildContext context, dynamic error) {
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context);
    if (error.toString().contains('permission')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.get('permission_required')),
          content: Text(l10n.get('permission_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.get('cancel')),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: Text(l10n.get('open_settings')),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n
              .get('error_exporting')
              .replaceAll('{error}', error.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'am':
        return 'አማርኛ';
      default:
        return 'English';
    }
  }

  Future<void> _handleImport(String type) async {
    try {
      debugPrint('Starting import process for type: $type');

      // Get the import service
      final exportService = ExportService();

      // Import the data
      final importedTransactions = type == 'CSV'
          ? await exportService.importFromCSV()
          : await exportService.importFromExcel();

      debugPrint(
          'Successfully imported ${importedTransactions.length} transactions');

      if (importedTransactions.isEmpty) {
        debugPrint('No transactions found in the imported file');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context).get('no_transactions_found')),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Add transactions
      debugPrint('Adding imported transactions to the database');
      for (final transaction in importedTransactions) {
        debugPrint('Adding transaction: ${transaction.toString()}');
        await widget.addTransaction(transaction);
      }

      debugPrint('Successfully added all transactions to the database');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).get('import_success').replaceAll(
                    '{count}',
                    '${importedTransactions.length} transactions',
                  ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error during import: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .get('error_importing')
                  .replaceAll('{error}', e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_balance,
                    size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'AMBO UNIVERSITY\nHACHALU HUNDESSA CAMPUS\nSCHOOL OF INFORMATICS AND ELECTRICAL ENGINEERING\nDepartment of Computer Science',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Expense Tracking and Budget Management System',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Text(
                  'Developed by:',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTeamList(),
                const SizedBox(height: 24),
                Text(
                  '© ${DateTime.now().year} Ambo University',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamList() {
    final members = [
      {'name': 'Sena Alemu', 'id': 'Uget/237/13'},
      {'name': 'Lemi Gutu', 'id': 'Uget/220/13'},
      {'name': 'Genet Tsegaye', 'id': 'Uget/352/13'},
      {'name': 'Samuel Girma', 'id': 'Uget/236/13'},
      {'name': 'Girma Desta', 'id': 'Uget/202/13'},
    ];
    final theme = Theme.of(context);
    final headingColor = theme.colorScheme.surfaceVariant;
    final rowColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    return DataTable(
      columns: [
        DataColumn(
          label: Text('Name',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        ),
        DataColumn(
          label: Text('ID',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        ),
      ],
      rows: members
          .map(
            (m) => DataRow(
              cells: [
                DataCell(Text(m['name']!, style: TextStyle(color: textColor))),
                DataCell(Text(m['id']!, style: TextStyle(color: textColor))),
              ],
            ),
          )
          .toList(),
      headingRowColor: MaterialStateProperty.resolveWith(
        (states) => headingColor,
      ),
      dataRowColor: MaterialStateProperty.resolveWith(
        (states) => rowColor,
      ),
      columnSpacing: 24,
      horizontalMargin: 0,
      dividerThickness: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;

        return Scaffold(
          body: Stack(
            children: [
              // Background gradient
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Content
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 48.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Header
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      theme.colorScheme.shadow.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.colorScheme.primary,
                                      ),
                                      child: ClipOval(
                                        child: _buildProfileImage(
                                          user?.image,
                                          user?.firstName,
                                          theme,
                                        ),
                                      ),
                                    ),
                                    // Only show edit button for non-guest users
                                    if (state.user != null &&
                                        !state.user!.isGuest)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.colorScheme.primary
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    EditProfileDialog(
                                                  onImageSelected:
                                                      _updateLocalImage,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '${user?.firstName} ${user?.lastName}',
                                  textAlign: TextAlign.center,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Only show email for non-guest users
                                if (state.user != null && !state.user!.isGuest)
                                  Text(
                                    user?.email ?? '',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Account Settings Section
                          if (state.user != null && !state.user!.isGuest) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                l10n.get('account_settings'),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: theme.colorScheme.outline
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Only show edit profile for non-guest users
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    title: Text(l10n.get('edit_profile')),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => EditProfileDialog(
                                          onImageSelected: _updateLocalImage,
                                        ),
                                      );
                                    },
                                  ),
                                  // Only show change password for non-guest users
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.lock,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    title: Text(l10n.get('change_password')),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const ChangePasswordDialog(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],

                          // Preferences Section
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              l10n.get('preferences'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color:
                                    theme.colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.palette,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(l10n.get('appearance')),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _showThemeDialog(context),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.currency_exchange,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(l10n.get('currency')),
                                  subtitle: Text(
                                    user?.currency ?? 'Birr',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _showCurrencyDialog(context),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.language,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(l10n.get('language')),
                                  subtitle: Text(
                                    _getLanguageName(user?.language ?? 'en'),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _showLanguageDialog(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Export Data Section
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              l10n.get('export_data'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color:
                                    theme.colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.download,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(l10n.get('export_data')),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () =>
                                      _showExportDialog(context, _transactions),
                                ),
                                const Divider(
                                    height: 1, indent: 20, endIndent: 20),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.upload,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(l10n.get('import_data')),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _showImportDialog(context),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.info,
                                        color: theme.colorScheme.primary),
                                  ),
                                  title: Text('About'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _showAboutDialog(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Sign Out Button
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showLogoutDialog(context),
                              icon: const Icon(Icons.logout),
                              label: Text(l10n.get('sign_out')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                foregroundColor: theme.colorScheme.onError,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
