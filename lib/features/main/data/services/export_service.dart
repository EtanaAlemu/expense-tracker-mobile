import 'dart:io';
import 'dart:math';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart'
    as app_category;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:get_it/get_it.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:expense_tracker/core/theme/app_icons.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart' as base;
import 'package:expense_tracker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart'
    as category_usecase;
import 'package:expense_tracker/core/usecase/usecase.dart' as usecase;

class ExportService {
  final GetTransactions _getTransactions;
  final GetCurrentUserUseCase _getCurrentUser;
  final category_usecase.GetCategories _getCategories;

  ExportService()
      : _getTransactions = GetIt.instance<GetTransactions>(),
        _getCurrentUser = GetIt.instance<GetCurrentUserUseCase>(),
        _getCategories = GetIt.instance<category_usecase.GetCategories>();

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      // For Android 11 and above, we need to request manage storage permission
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      return false;
    }

    // For iOS, we only need to request storage permission
    return await Permission.storage.request().isGranted;
  }

  Future<void> exportToCSV() async {
    try {
      debugPrint('Starting CSV export');

      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        debugPrint('Storage permission not granted');
        throw Exception(
            'Storage permission not granted. Please grant storage permission in app settings.');
      }

      // Get current user
      final userResult = await _getCurrentUser(usecase.NoParams());
      final user = userResult.fold(
        (failure) => throw Exception('Failed to get current user: $failure'),
        (user) => user,
      );

      // Get categories using the use case
      final categoriesResult = await _getCategories(base.UserParams(userId: user.id));
      final categories = categoriesResult.fold(
        (failure) => throw Exception('Failed to get categories: $failure'),
        (categories) => categories,
      );
      debugPrint('Retrieved ${categories.length} categories');

      // Get transactions using the use case
      final result = await _getTransactions(base.UserParams(userId: user.id));
      final transactions = result.fold(
        (failure) => throw Exception('Failed to get transactions: $failure'),
        (transactions) => transactions,
      );
      debugPrint('Retrieved ${transactions.length} transactions');

      if (transactions.isEmpty) {
        debugPrint('No transactions to export');
        throw Exception('No transactions to export');
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now();
      final formattedDate =
          '${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}${timestamp.second.toString().padLeft(2, '0')}';
      final file = File('${directory.path}/Expense_Tracker_$formattedDate.csv');
      debugPrint('File path: ${file.path}');

      final csvContent = StringBuffer();
      // Add headers
      csvContent.writeln(
          'TransactionId,TransactionUserId,TransactionType,TransactionAmount,TransactionCategoryId,TransactionTitle,TransactionDescription,TransactionDate,TransactionIsSynced,TransactionIsDeleted,TransactionIsUpdated,' +
              'CategoryId,CategoryName,CategoryType,CategoryColor,CategoryIcon,CategoryBudget,CategoryDescription,CategoryCreatedAt,CategoryUpdatedAt,CategoryUserId,CategoryIsDefault,CategoryIsSynced,CategoryIsUpdated,CategoryIsDeleted,CategoryTransactionType,CategoryFrequency,CategoryDefaultAmount,CategoryIsActive,CategoryIsRecurring,CategoryLastProcessedDate,CategoryNextProcessedDate');

      // Add data
      for (var transaction in transactions) {
        final category = categories.firstWhere(
          (c) => c.id == transaction.categoryId,
          orElse: () => app_category.Category(
            id: transaction.categoryId,
            name: 'Unknown',
            type: 'unknown',
            color: material.Colors.grey,
            icon: AppIcons.getRandomIcon(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: '',
          ),
        );

        csvContent.writeln(
            '${transaction.id},${transaction.userId},${transaction.type},${transaction.amount},${transaction.categoryId},${transaction.title},${transaction.description},${transaction.date},${transaction.isSynced},${transaction.isDeleted},${transaction.isUpdated},' +
                '${category.id},${category.name},${category.type},${category.color.value},${category.icon.codePoint},${category.budget},${category.description},${category.createdAt},${category.updatedAt},${category.userId},${category.isDefault},${category.isSynced},${category.isUpdated},${category.isDeleted},${category.transactionType},${category.frequency},${category.defaultAmount},${category.isActive},${category.isRecurring},${category.lastProcessedDate},${category.nextProcessedDate}');
      }

      await file.writeAsString(csvContent.toString());
      debugPrint('CSV file written successfully');

      await Share.shareXFiles([XFile(file.path)],
          text: 'Transaction Data (CSV)');
      debugPrint('CSV file shared successfully');
    } catch (e, stackTrace) {
      debugPrint('Error in CSV export: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> exportToExcel() async {
    try {
      debugPrint('Starting Excel export');

      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        debugPrint('Storage permission not granted');
        throw Exception(
            'Storage permission not granted. Please grant storage permission in app settings.');
      }

      // Get current user
      final userResult = await _getCurrentUser(usecase.NoParams());
      final user = userResult.fold(
        (failure) => throw Exception('Failed to get current user: $failure'),
        (user) => user,
      );

      // Get categories using the use case
      final categoriesResult = await _getCategories(base.UserParams(userId: user.id));
      final categories = categoriesResult.fold(
        (failure) => throw Exception('Failed to get categories: $failure'),
        (categories) => categories,
      );
      debugPrint('Retrieved ${categories.length} categories');

      // Get transactions using the use case
      final result = await _getTransactions(base.UserParams(userId: user.id));
      final transactions = result.fold(
        (failure) => throw Exception('Failed to get transactions: $failure'),
        (transactions) => transactions,
      );
      debugPrint('Retrieved ${transactions.length} transactions');

      if (transactions.isEmpty) {
        debugPrint('No transactions to export');
        throw Exception('No transactions to export');
      }

      final excel = Excel.createExcel();
      final sheet = excel.sheets.values.first;
      debugPrint('Excel sheet created');

      // Add headers for Excel
      sheet.appendRow([
        'TransactionId',
        'TransactionUserId',
        'TransactionType',
        'TransactionAmount',
        'TransactionCategoryId',
        'TransactionTitle',
        'TransactionDescription',
        'TransactionDate',
        'TransactionIsSynced',
        'TransactionIsDeleted',
        'TransactionIsUpdated',
        'CategoryId',
        'CategoryName',
        'CategoryType',
        'CategoryColor',
        'CategoryIcon',
        'CategoryBudget',
        'CategoryDescription',
        'CategoryCreatedAt',
        'CategoryUpdatedAt',
        'CategoryUserId',
        'CategoryIsDefault',
        'CategoryIsSynced',
        'CategoryIsUpdated',
        'CategoryIsDeleted',
        'CategoryTransactionType',
        'CategoryFrequency',
        'CategoryDefaultAmount',
        'CategoryIsActive',
        'CategoryIsRecurring',
        'CategoryLastProcessedDate',
        'CategoryNextProcessedDate'
      ]);

      // Add data for Excel
      for (var transaction in transactions) {
        final category = categories.firstWhere(
          (c) => c.id == transaction.categoryId,
          orElse: () => app_category.Category(
            id: transaction.categoryId,
            name: 'Unknown',
            type: 'unknown',
            color: material.Colors.grey,
            icon: AppIcons.getRandomIcon(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: '',
          ),
        );

        sheet.appendRow([
          transaction.id,
          transaction.userId,
          transaction.type,
          transaction.amount.toString(),
          transaction.categoryId,
          transaction.title,
          transaction.description,
          transaction.date.toString(),
          transaction.isSynced.toString(),
          transaction.isDeleted.toString(),
          transaction.isUpdated.toString(),
          category.id,
          category.name,
          category.type,
          category.color.value.toString(),
          category.icon.codePoint.toString(),
          category.budget?.toString() ?? '',
          category.description ?? '',
          category.createdAt.toString(),
          category.updatedAt.toString(),
          category.userId,
          category.isDefault.toString(),
          category.isSynced.toString(),
          category.isUpdated.toString(),
          category.isDeleted.toString(),
          category.transactionType,
          category.frequency ?? '',
          category.defaultAmount?.toString() ?? '',
          category.isActive.toString(),
          category.isRecurring.toString(),
          category.lastProcessedDate?.toString() ?? '',
          category.nextProcessedDate?.toString() ?? ''
        ]);
      }
      debugPrint('Data added to Excel sheet');

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now();
      final formattedDate =
          '${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}${timestamp.second.toString().padLeft(2, '0')}';
      final file =
          File('${directory.path}/Expense_Tracker_$formattedDate.xlsx');
      debugPrint('File path: ${file.path}');

      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Failed to encode Excel file');
      }

      await file.writeAsBytes(bytes);
      debugPrint('Excel file written successfully');

      await Share.shareXFiles([XFile(file.path)],
          text: 'Transaction Data (Excel)');
      debugPrint('Excel file shared successfully');
    } catch (e, stackTrace) {
      debugPrint('Error in Excel export: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> exportToPDF() async {
    try {
      debugPrint('Starting PDF export');

      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        debugPrint('Storage permission not granted');
        throw Exception(
            'Storage permission not granted. Please grant storage permission in app settings.');
      }

      // Get current user
      final userResult = await _getCurrentUser(usecase.NoParams());
      final user = userResult.fold(
        (failure) => throw Exception('Failed to get current user: $failure'),
        (user) => user,
      );

      // Get categories using the use case
      final categoriesResult = await _getCategories(base.UserParams(userId: user.id));
      final categories = categoriesResult.fold(
        (failure) => throw Exception('Failed to get categories: $failure'),
        (categories) => categories,
      );
      debugPrint('Retrieved ${categories.length} categories');

      // Get transactions using the use case
      final result = await _getTransactions(base.UserParams(userId: user.id));
      final transactions = result.fold(
        (failure) => throw Exception('Failed to get transactions: $failure'),
        (transactions) => transactions,
      );
      debugPrint('Retrieved ${transactions.length} transactions');

      if (transactions.isEmpty) {
        debugPrint('No transactions to export');
        throw Exception('No transactions to export');
      }

      final pdf = pw.Document();
      debugPrint('PDF document created');

      // Helper function to wrap text
      pw.Widget _wrapText(String text, {int maxLines = 2}) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            text,
            style: const pw.TextStyle(fontSize: 8),
            maxLines: maxLines,
            overflow: pw.TextOverflow.clip,
          ),
        );
      }

      // Add Transactions table
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Transactions',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  'Title',
                  'Description',
                  'Type',
                  'Amount',
                  'Category Name',
                  'Date',
                ],
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blue,
                ),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerLeft,
                  5: pw.Alignment.center,
                },
                data: transactions.map((t) {
                  final category = categories.firstWhere(
                    (c) => c.id == t.categoryId,
                    orElse: () => app_category.Category(
                      id: t.categoryId,
                      name: 'Unknown',
                      type: 'unknown',
                      color: material.Colors.grey,
                      icon: AppIcons.getRandomIcon(),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      userId: '',
                    ),
                  );

                  return [
                    _wrapText(t.title),
                    _wrapText(t.description, maxLines: 3),
                    _wrapText(t.type),
                    _wrapText(t.amount.toString()),
                    _wrapText(category.name),
                    _wrapText(t.date.toString()),
                  ];
                }).toList(),
              ),
            ],
          ),
        ),
      );

      // Add Categories table
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Categories',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  'Name',
                  'Description',
                  'Type',
                  'Budget',
                  'Transaction Type',
                  'Frequency',
                  'Default Amount',
                ],
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blue,
                ),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.center,
                  5: pw.Alignment.center,
                  6: pw.Alignment.centerRight,
                },
                data: categories.map((c) {
                  return [
                    _wrapText(c.name),
                    _wrapText(c.description ?? '', maxLines: 3),
                    _wrapText(c.type),
                    _wrapText(c.budget?.toString() ?? ''),
                    _wrapText(c.transactionType),
                    _wrapText(c.frequency ?? ''),
                    _wrapText(c.defaultAmount?.toString() ?? ''),
                  ];
                }).toList(),
              ),
            ],
          ),
        ),
      );

      debugPrint('Data added to PDF document');

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now();
      final formattedDate =
          '${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}${timestamp.second.toString().padLeft(2, '0')}';
      final file = File('${directory.path}/Expense_Tracker_$formattedDate.pdf');
      debugPrint('File path: ${file.path}');

      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);
      debugPrint('PDF file written successfully');

      await Share.shareXFiles([XFile(file.path)],
          text: 'Transaction Data (PDF)');
      debugPrint('PDF file shared successfully');
    } catch (e, stackTrace) {
      debugPrint('Error in PDF export: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Helper method to parse date strings
  DateTime _parseDate(String dateStr) {
    try {
      // Try parsing ISO format first
      return DateTime.parse(dateStr);
    } catch (e) {
      try {
        // Try parsing common date formats
        final formats = [
          'yyyy-MM-dd HH:mm:ss',
          'yyyy-MM-dd HH:mm',
          'yyyy-MM-dd',
          'dd/MM/yyyy HH:mm:ss',
          'dd/MM/yyyy HH:mm',
          'dd/MM/yyyy',
          'MM/dd/yyyy HH:mm:ss',
          'MM/dd/yyyy HH:mm',
          'MM/dd/yyyy',
        ];

        for (final format in formats) {
          try {
            final parts = dateStr.split(RegExp(r'[-\s/:]'));
            if (parts.length >= 3) {
              int year = int.parse(parts[0]);
              int month = int.parse(parts[1]);
              int day = int.parse(parts[2]);
              int hour = parts.length > 3 ? int.parse(parts[3]) : 0;
              int minute = parts.length > 4 ? int.parse(parts[4]) : 0;
              int second = parts.length > 5 ? int.parse(parts[5]) : 0;
              return DateTime(year, month, day, hour, minute, second);
            }
          } catch (e) {
            continue;
          }
        }
      } catch (e) {
        debugPrint('Error parsing date: $dateStr');
      }
    }
    // Return current date as fallback
    return DateTime.now();
  }

  // Helper method to create IconData from codePoint
  IconData _getIconFromCodePoint(int codePoint) {
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }

  Future<List<Transaction>> importFromCSV() async {
    try {
      debugPrint('Starting CSV import');

      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        debugPrint('Storage permission not granted');
        throw Exception(
            'Storage permission not granted. Please grant storage permission in app settings.');
      }

      debugPrint('Requesting file picker for CSV');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null) {
        debugPrint('No file selected by user');
        throw Exception('No file selected');
      }

      debugPrint('File selected: ${result.files.single.name}');
      debugPrint('File path: ${result.files.single.path}');

      final file = File(result.files.single.path!);
      debugPrint('Reading file contents');
      final contents = await file.readAsString();
      debugPrint('File contents length: ${contents.length}');
      debugPrint(
          'First 100 characters of file: ${contents.substring(0, min(100, contents.length))}');

      debugPrint('Converting CSV to list');
      final rows = const CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
        textDelimiter: '"',
      ).convert(contents);
      debugPrint('Number of rows in CSV: ${rows.length}');

      if (rows.isEmpty) {
        debugPrint('CSV file is empty');
        throw Exception('File is empty');
      }

      // Verify header format
      final headers =
          rows[0].map((header) => header.toString().trim()).toList();
      debugPrint('CSV Headers (trimmed): $headers');
      if (headers.length < 31 || // Check for minimum required fields
          !headers.contains('TransactionId') ||
          !headers.contains('TransactionUserId') ||
          !headers.contains('TransactionType') ||
          !headers.contains('TransactionAmount') ||
          !headers.contains('TransactionCategoryId') ||
          !headers.contains('TransactionTitle') ||
          !headers.contains('TransactionDescription') ||
          !headers.contains('TransactionDate') ||
          !headers.contains('CategoryId') ||
          !headers.contains('CategoryName') ||
          !headers.contains('CategoryType')) {
        debugPrint(
            'Invalid CSV format. Expected headers: TransactionId,TransactionUserId,TransactionType,TransactionAmount,TransactionCategoryId,TransactionTitle,TransactionDescription,TransactionDate,TransactionIsSynced,TransactionIsDeleted,TransactionIsUpdated,CategoryId,CategoryName,CategoryType,...');
        throw Exception(
            'Invalid CSV format. Please use the exported CSV format.');
      }

      // Skip header row
      final dataRows = rows.skip(1);
      debugPrint('Number of data rows (excluding header): ${dataRows.length}');
      final transactions = <Transaction>[];

      // Get all categories
      final categoryBloc = GetIt.instance<CategoryBloc>();
      categoryBloc.add(GetCategories());
      await Future.delayed(
          const Duration(milliseconds: 500)); // Wait for categories to load
      final categoryState = categoryBloc.state;
      if (categoryState is! CategoryLoaded) {
        throw Exception('Failed to load categories');
      }
      final categories = categoryState.categories ?? [];

      // First, create all unique categories
      final uniqueCategories = <String, app_category.Category>{};
      for (var row in dataRows) {
        if (row.length < 31) continue; // Skip if not enough fields

        final categoryId = row[headers.indexOf('CategoryId')].toString().trim();
        final categoryName =
            row[headers.indexOf('CategoryName')].toString().trim();
        final categoryType =
            row[headers.indexOf('CategoryType')].toString().trim();
        final categoryKey = '${categoryName}_$categoryType';

        if (!uniqueCategories.containsKey(categoryKey)) {
          // Check if category already exists
          final existingCategory = categories.firstWhere(
            (c) => c.id == categoryId,
            orElse: () {
              // Create new category if it doesn't exist
              final colorValue = int.tryParse(
                      row[headers.indexOf('CategoryColor')]
                          .toString()
                          .trim()) ??
                  material.Colors.blue.value;
              final iconCodePoint = int.tryParse(
                      row[headers.indexOf('CategoryIcon')].toString().trim()) ??
                  Icons.category.codePoint;

              final newCategory = app_category.Category(
                id: categoryId,
                name: categoryName,
                type: categoryType,
                color: material.Color(colorValue),
                icon: _getIconFromCodePoint(iconCodePoint),
                createdAt: _parseDate(row[headers.indexOf('CategoryCreatedAt')]
                    .toString()
                    .trim()),
                updatedAt: _parseDate(row[headers.indexOf('CategoryUpdatedAt')]
                    .toString()
                    .trim()),
                userId:
                    row[headers.indexOf('CategoryUserId')].toString().trim(),
                isDefault: row[headers.indexOf('CategoryIsDefault')]
                        .toString()
                        .trim() ==
                    'true',
                isSynced: row[headers.indexOf('CategoryIsSynced')]
                        .toString()
                        .trim() ==
                    'true',
                isUpdated: row[headers.indexOf('CategoryIsUpdated')]
                        .toString()
                        .trim() ==
                    'true',
                isDeleted: row[headers.indexOf('CategoryIsDeleted')]
                        .toString()
                        .trim() ==
                    'true',
                transactionType: row[headers.indexOf('CategoryTransactionType')]
                    .toString()
                    .trim(),
                frequency:
                    row[headers.indexOf('CategoryFrequency')].toString().trim(),
                defaultAmount: double.tryParse(
                    row[headers.indexOf('CategoryDefaultAmount')]
                        .toString()
                        .trim()),
                isActive: row[headers.indexOf('CategoryIsActive')]
                        .toString()
                        .trim() ==
                    'true',
                isRecurring: row[headers.indexOf('CategoryIsRecurring')]
                        .toString()
                        .trim() ==
                    'true',
                lastProcessedDate:
                    row[headers.indexOf('CategoryLastProcessedDate')]
                            .toString()
                            .trim()
                            .isNotEmpty
                        ? _parseDate(
                            row[headers.indexOf('CategoryLastProcessedDate')]
                                .toString()
                                .trim())
                        : null,
                nextProcessedDate:
                    row[headers.indexOf('CategoryNextProcessedDate')]
                            .toString()
                            .trim()
                            .isNotEmpty
                        ? _parseDate(
                            row[headers.indexOf('CategoryNextProcessedDate')]
                                .toString()
                                .trim())
                        : null,
              );

              // Add the new category to the bloc
              categoryBloc.add(AddCategory(newCategory));
              debugPrint(
                  '➕ Created new category: ${newCategory.name} (${newCategory.id})');
              return newCategory;
            },
          );
          uniqueCategories[categoryKey] = existingCategory;
        }
      }

      // Wait for categories to be created
      await Future.delayed(const Duration(milliseconds: 1000));

      // Now create transactions using the created categories
      for (var row in dataRows) {
        debugPrint('Processing row: $row');
        if (row.length < 31) {
          debugPrint('Skipping invalid row (length < 31): $row');
          continue;
        }

        try {
          debugPrint('Parsing transaction from row: $row');

          // Create transaction with all fields
          final transaction = Transaction(
            id: row[headers.indexOf('TransactionId')].toString().trim(),
            userId: row[headers.indexOf('TransactionUserId')].toString().trim(),
            type: row[headers.indexOf('TransactionType')].toString().trim(),
            amount: double.parse(
                row[headers.indexOf('TransactionAmount')].toString().trim()),
            categoryId:
                row[headers.indexOf('TransactionCategoryId')].toString().trim(),
            title: row[headers.indexOf('TransactionTitle')].toString().trim(),
            description: row[headers.indexOf('TransactionDescription')]
                .toString()
                .trim(),
            date: _parseDate(
                row[headers.indexOf('TransactionDate')].toString().trim()),
            isSynced:
                row[headers.indexOf('TransactionIsSynced')].toString().trim() ==
                    'true',
            isDeleted: row[headers.indexOf('TransactionIsDeleted')]
                    .toString()
                    .trim() ==
                'true',
            isUpdated: row[headers.indexOf('TransactionIsUpdated')]
                    .toString()
                    .trim() ==
                'true',
          );

          debugPrint(
              'Successfully parsed transaction: ${transaction.toString()}');
          transactions.add(transaction);
        } catch (e) {
          debugPrint('Error parsing row: $e');
          debugPrint('Problematic row data: $row');
          continue;
        }
      }

      debugPrint(
          'Successfully imported ${transactions.length} transactions from CSV');
      return transactions;
    } catch (e, stackTrace) {
      debugPrint('Error in CSV import: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<Transaction>> importFromExcel() async {
    try {
      debugPrint('Starting Excel import');

      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        debugPrint('Storage permission not granted');
        throw Exception(
            'Storage permission not granted. Please grant storage permission in app settings.');
      }

      debugPrint('Requesting file picker for Excel');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null) {
        debugPrint('No file selected by user');
        throw Exception('No file selected');
      }

      debugPrint('File selected: ${result.files.single.name}');
      debugPrint('File path: ${result.files.single.path}');

      final file = File(result.files.single.path!);
      debugPrint('Reading Excel file');
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      // Get the first sheet
      final sheet = excel.tables.keys.first;
      debugPrint('Using sheet: $sheet');

      final rows = excel.tables[sheet]!.rows;
      debugPrint('Number of rows in Excel: ${rows.length}');

      if (rows.isEmpty) {
        debugPrint('Excel file is empty');
        throw Exception('File is empty');
      }

      // Verify header format
      final headers =
          rows[0].map((cell) => cell?.value?.toString().trim() ?? '').toList();
      debugPrint('Excel Headers (trimmed): $headers');
      if (headers.length < 31 || // Check for minimum required fields
          !headers.contains('TransactionId') ||
          !headers.contains('TransactionUserId') ||
          !headers.contains('TransactionType') ||
          !headers.contains('TransactionAmount') ||
          !headers.contains('TransactionCategoryId') ||
          !headers.contains('TransactionTitle') ||
          !headers.contains('TransactionDescription') ||
          !headers.contains('TransactionDate') ||
          !headers.contains('CategoryId') ||
          !headers.contains('CategoryName') ||
          !headers.contains('CategoryType')) {
        debugPrint(
            'Invalid Excel format. Expected headers: TransactionId,TransactionUserId,TransactionType,TransactionAmount,TransactionCategoryId,TransactionTitle,TransactionDescription,TransactionDate,TransactionIsSynced,TransactionIsDeleted,TransactionIsUpdated,CategoryId,CategoryName,CategoryType,...');
        throw Exception(
            'Invalid Excel format. Please use the exported Excel format.');
      }

      // Skip header row
      final dataRows = rows.skip(1);
      debugPrint('Number of data rows (excluding header): ${dataRows.length}');
      final transactions = <Transaction>[];

      // Get all categories
      final categoryBloc = GetIt.instance<CategoryBloc>();
      categoryBloc.add(GetCategories());
      await Future.delayed(
          const Duration(milliseconds: 500)); // Wait for categories to load
      final categoryState = categoryBloc.state;
      if (categoryState is! CategoryLoaded) {
        throw Exception('Failed to load categories');
      }
      final categories = categoryState.categories ?? [];

      // First, create all unique categories
      final uniqueCategories = <String, app_category.Category>{};
      for (var row in dataRows) {
        if (row.length < 31) continue;

        final categoryId =
            row[headers.indexOf('CategoryId')]?.value?.toString().trim() ?? '';
        final categoryName =
            row[headers.indexOf('CategoryName')]?.value?.toString().trim() ??
                'Unknown';
        final categoryType =
            row[headers.indexOf('CategoryType')]?.value?.toString().trim() ??
                'unknown';
        final categoryKey = '${categoryName}_$categoryType';

        if (!uniqueCategories.containsKey(categoryKey)) {
          // Check if category already exists
          final existingCategory = categories.firstWhere(
            (c) => c.id == categoryId,
            orElse: () {
              // Create new category if it doesn't exist
              final colorValue = int.tryParse(
                  row[headers.indexOf('CategoryColor')]
                          ?.value
                          ?.toString()
                          .trim() ??
                      material.Colors.blue.value.toString());
              final iconCodePoint = int.tryParse(
                  row[headers.indexOf('CategoryIcon')]
                          ?.value
                          ?.toString()
                          .trim() ??
                      Icons.category.codePoint.toString());

              final newCategory = app_category.Category(
                id: categoryId,
                name: categoryName,
                type: categoryType,
                color: material.Color(colorValue ?? material.Colors.blue.value),
                icon: _getIconFromCodePoint(
                    iconCodePoint ?? Icons.category.codePoint),
                createdAt: DateTime.parse(
                    row[headers.indexOf('CategoryCreatedAt')]
                            ?.value
                            ?.toString()
                            .trim() ??
                        DateTime.now().toString()),
                updatedAt: DateTime.parse(
                    row[headers.indexOf('CategoryUpdatedAt')]
                            ?.value
                            ?.toString()
                            .trim() ??
                        DateTime.now().toString()),
                userId: row[headers.indexOf('CategoryUserId')]
                        ?.value
                        ?.toString()
                        .trim() ??
                    '',
                isDefault: row[headers.indexOf('CategoryIsDefault')]
                        ?.value
                        ?.toString()
                        .trim() ==
                    'true',
                isSynced: row[headers.indexOf('CategoryIsSynced')]
                        ?.value
                        ?.toString()
                        .trim() ==
                    'true',
                isUpdated: row[headers.indexOf('CategoryIsUpdated')]
                        ?.value
                        ?.toString()
                        .trim() ==
                    'true',
                isDeleted: row[headers.indexOf('CategoryIsDeleted')]
                        ?.value
                        ?.toString()
                        .trim() ==
                    'true',
                transactionType: row[headers.indexOf('CategoryTransactionType')]
                        ?.value
                        ?.toString()
                        .trim() ??
                    'one-time',
                frequency: row[headers.indexOf('CategoryFrequency')]
                    ?.value
                    ?.toString()
                    .trim(),
                defaultAmount: double.tryParse(
                    row[headers.indexOf('CategoryDefaultAmount')]
                            ?.value
                            ?.toString()
                            .trim() ??
                        ''),
                isActive: row[headers.indexOf('CategoryIsActive')]
                        ?.value
                        ?.toString()
                        .trim() ==
                    'true',
                isRecurring: row[headers.indexOf('CategoryIsRecurring')]
                        ?.value
                        ?.toString()
                        .trim() ==
                    'true',
                lastProcessedDate:
                    row[headers.indexOf('CategoryLastProcessedDate')]
                                ?.value
                                ?.toString()
                                .trim()
                                ?.isNotEmpty ==
                            true
                        ? DateTime.parse(
                            row[headers.indexOf('CategoryLastProcessedDate')]
                                    ?.value
                                    ?.toString()
                                    .trim() ??
                                '')
                        : null,
                nextProcessedDate:
                    row[headers.indexOf('CategoryNextProcessedDate')]
                                ?.value
                                ?.toString()
                                .trim()
                                ?.isNotEmpty ==
                            true
                        ? DateTime.parse(
                            row[headers.indexOf('CategoryNextProcessedDate')]
                                    ?.value
                                    ?.toString()
                                    .trim() ??
                                '')
                        : null,
              );

              // Add the new category to the bloc
              categoryBloc.add(AddCategory(newCategory));
              debugPrint(
                  '➕ Created new category: ${newCategory.name} (${newCategory.id})');
              return newCategory;
            },
          );
          uniqueCategories[categoryKey] = existingCategory;
        }
      }

      // Wait for categories to be created
      await Future.delayed(const Duration(milliseconds: 1000));

      // Now create transactions using the created categories
      for (var row in dataRows) {
        debugPrint('Processing row: $row');
        if (row.length < 31) {
          debugPrint('Skipping invalid row (length < 31): $row');
          continue;
        }

        try {
          debugPrint('Parsing transaction from row: $row');

          // Create transaction with all fields
          final transaction = Transaction(
            id: row[headers.indexOf('TransactionId')]
                    ?.value
                    ?.toString()
                    .trim() ??
                '',
            userId: row[headers.indexOf('TransactionUserId')]
                    ?.value
                    ?.toString()
                    .trim() ??
                '',
            type: row[headers.indexOf('TransactionType')]
                    ?.value
                    ?.toString()
                    .trim() ??
                'Expense',
            amount: double.parse(row[headers.indexOf('TransactionAmount')]
                    ?.value
                    ?.toString()
                    .trim() ??
                '0'),
            categoryId: row[headers.indexOf('TransactionCategoryId')]
                    ?.value
                    ?.toString()
                    .trim() ??
                '',
            title: row[headers.indexOf('TransactionTitle')]
                    ?.value
                    ?.toString()
                    .trim() ??
                '',
            description: row[headers.indexOf('TransactionDescription')]
                    ?.value
                    ?.toString()
                    .trim() ??
                '',
            date: DateTime.parse(row[headers.indexOf('TransactionDate')]
                    ?.value
                    ?.toString()
                    .trim() ??
                DateTime.now().toString()),
            isSynced: row[headers.indexOf('TransactionIsSynced')]
                    ?.value
                    ?.toString()
                    .trim() ==
                'true',
            isDeleted: row[headers.indexOf('TransactionIsDeleted')]
                    ?.value
                    ?.toString()
                    .trim() ==
                'true',
            isUpdated: row[headers.indexOf('TransactionIsUpdated')]
                    ?.value
                    ?.toString()
                    .trim() ==
                'true',
          );

          debugPrint(
              'Successfully parsed transaction: ${transaction.toString()}');
          transactions.add(transaction);
        } catch (e) {
          debugPrint('Error parsing row: $e');
          debugPrint('Problematic row data: $row');
          continue;
        }
      }

      debugPrint(
          'Successfully imported ${transactions.length} transactions from Excel');
      return transactions;
    } catch (e, stackTrace) {
      debugPrint('Error in Excel import: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
