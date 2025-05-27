import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print('🔔 Background notification tapped: ${response.payload}');
  // Handle background notification tap
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final TransactionRepository _transactionRepository;
  final AuthRepository _authRepository;

  NotificationService({
    required TransactionRepository transactionRepository,
    required AuthRepository authRepository,
  })  : _transactionRepository = transactionRepository,
        _authRepository = authRepository {
    _initializeNotifications();
  }

  // Add a set to track recently shown notifications
  final Set<String> _recentlyShownNotifications = {};

  Future<String> _getUserId() async {
    final userResult = await _authRepository.getCurrentUser();
    return userResult.fold(
      (failure) {
        print('❌ Failed to get current user: ${failure.message}');
        return '';
      },
      (user) => user.id,
    );
  }

  void _initializeNotifications() {
    // Initialize timezone
    tz.initializeTimeZones();
    print('🕒 Timezone location: ${tz.local.name}');

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'transaction_channel',
      'Transaction Notifications',
      description: 'Notifications for upcoming transactions',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    // Create the Android notification channel
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      androidPlugin.createNotificationChannel(androidChannel);
      print('✅ Created Android notification channel');
    }

    // Initialize notification settings
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with response handlers
    _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 Notification tapped: ${response.payload}');
        // Handle notification tap
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    print('✅ Initialized notification service');
  }

  Future<bool> requestPermissions() async {
    try {
      // Request Android permissions
      final androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        if (granted == false) {
          print('❌ Android notification permissions not granted');
          return false;
        }
      }

      // Request iOS permissions
      final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        if (granted == false) {
          print('❌ iOS notification permissions not granted');
          return false;
        }
      }

      print('✅ Notification permissions granted');
      return true;
    } catch (e) {
      print('❌ Error requesting notification permissions: $e');
      return false;
    }
  }

  Future<bool> checkPermissions() async {
    try {
      // Check Android permissions
      final androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.areNotificationsEnabled();
        if (granted == false) {
          print('❌ Android notifications not enabled');
          return false;
        }
      }

      // Check iOS permissions
      final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final settings = await iosPlugin.getNotificationAppLaunchDetails();
        if (settings?.didNotificationLaunchApp == false) {
          print('❌ iOS notifications not enabled');
          return false;
        }
      }

      return true;
    } catch (e) {
      print('❌ Error checking notification permissions: $e');
      return false;
    }
  }

  Future<void> scheduleTransactionNotification(Transaction transaction) async {
    try {
      // Generate a unique key for this transaction
      final notificationKey =
          '${transaction.id}_${transaction.date.millisecondsSinceEpoch}';

      // Check if we've shown this notification recently (within last 5 seconds)
      if (_recentlyShownNotifications.contains(notificationKey)) {
        print(
            '⚠️ Notification for this transaction was shown recently, skipping');
        return;
      }

      // Check if we have notification permissions
      final hasPermissions = await checkPermissions();
      if (!hasPermissions) {
        print('⚠️ Notification permissions not granted, requesting...');
        final granted = await requestPermissions();
        if (!granted) {
          print('❌ Cannot schedule notification: permissions not granted');
          return;
        }
      }

      // Get current time in local timezone
      final now = DateTime.now();
      print('Current time: ${now.toString()}');

      // Convert transaction date to local timezone
      final localDate = transaction.date.toLocal();
      print('Transaction date (local): ${localDate.toString()}');

      // Calculate notification time (1 hour before transaction)
      final scheduledTime = localDate.subtract(const Duration(hours: 1));
      print('Scheduled notification time: ${scheduledTime.toString()}');

      // Add safety check for minimum time difference
      final timeUntilNotification = scheduledTime.difference(now);
      print(
          'Time until notification: ${timeUntilNotification.inMinutes} minutes');

      // If notification time has passed or is too close, show it immediately
      if (scheduledTime.isBefore(now) || timeUntilNotification.inMinutes < 2) {
        print(
            '⚠️ Notification time has passed or is too close, showing immediately');
        print(
            'Time difference: ${timeUntilNotification.inMinutes.abs()} minutes');
        await _showImmediateNotification(transaction, notificationKey);
        return;
      }

      // Convert to TZDateTime for scheduling
      final scheduledTZTime = tz.TZDateTime.from(scheduledTime, tz.local);
      print('Scheduled TZDateTime: ${scheduledTZTime.toString()}');

      final androidDetails = AndroidNotificationDetails(
        'transaction_channel',
        'Transaction Notifications',
        channelDescription: 'Notifications for upcoming transactions',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        playSound: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        showWhen: true,
        autoCancel: false,
        ongoing: true,
        styleInformation: BigTextStyleInformation(
          '${transaction.type}: ${transaction.amount} - ${transaction.description}',
          htmlFormatBigText: true,
          contentTitle: 'Upcoming Transaction',
          htmlFormatContentTitle: true,
        ),
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Cancel any existing notification for this transaction
      await _notifications.cancel(transaction.hashCode);
      print(
          'Cancelled any existing notification for transaction ${transaction.id}');

      // Schedule the notification
      await _notifications.zonedSchedule(
        transaction.hashCode,
        'Upcoming Transaction',
        '${transaction.type}: ${transaction.amount} - ${transaction.description}',
        scheduledTZTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      print('✅ Successfully scheduled notification:');
      print('Transaction ID: ${transaction.id}');
      print('Notification ID: ${transaction.hashCode}');
      print('Will be shown at: ${scheduledTime.toString()}');
      print(
          'Time until notification: ${timeUntilNotification.inMinutes} minutes');
      print('Transaction time: ${localDate.toString()}');

      // Verify the scheduled notification
      final pendingNotifications =
          await _notifications.pendingNotificationRequests();
      final isScheduled = pendingNotifications
          .any((notification) => notification.id == transaction.hashCode);

      if (isScheduled) {
        print('✅ Verified: Notification is properly scheduled');
      } else {
        print('❌ Warning: Notification not found in pending notifications');
        // If scheduling failed, show immediately
        await _showImmediateNotification(transaction, notificationKey);
      }
    } catch (e, stackTrace) {
      print('❌ Failed to schedule notification: $e');
      print('Stack trace: $stackTrace');
      // If scheduling fails, show immediately
      await _showImmediateNotification(transaction,
          '${transaction.id}_${transaction.date.millisecondsSinceEpoch}');
    }
  }

  Future<void> _showImmediateNotification(
      Transaction transaction, String notificationKey) async {
    try {
      // Add to recently shown notifications
      _recentlyShownNotifications.add(notificationKey);

      // Remove from recently shown after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _recentlyShownNotifications.remove(notificationKey);
      });

      final androidDetails = AndroidNotificationDetails(
        'transaction_channel',
        'Transaction Notifications',
        channelDescription: 'Notifications for upcoming transactions',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        playSound: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        showWhen: true,
        styleInformation: BigTextStyleInformation(
          '${transaction.type}: ${transaction.amount} - ${transaction.description}',
          htmlFormatBigText: true,
          contentTitle: 'Transaction Reminder',
          htmlFormatContentTitle: true,
        ),
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Cancel any existing notification first
      await _notifications.cancel(transaction.hashCode);

      await _notifications.show(
        transaction.hashCode,
        'Transaction Reminder',
        '${transaction.type}: ${transaction.amount} - ${transaction.description}',
        details,
      );
      print(
          '✅ Shown immediate notification for transaction: ${transaction.id}');
    } catch (e) {
      print('❌ Failed to show immediate notification: $e');
    }
  }

  Future<void> cancelTransactionNotification(Transaction transaction) async {
    await _notifications.cancel(transaction.hashCode);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> showTestNotification() async {
    try {
      // Check if we have notification permissions
      final hasPermissions = await checkPermissions();
      if (!hasPermissions) {
        print('⚠️ Notification permissions not granted, requesting...');
        final granted = await requestPermissions();
        if (!granted) {
          print('❌ Cannot show test notification: permissions not granted');
          return;
        }
      }

      final androidDetails = AndroidNotificationDetails(
        'transaction_channel',
        'Transaction Notifications',
        channelDescription: 'Notifications for upcoming transactions',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        playSound: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        showWhen: true,
        styleInformation: BigTextStyleInformation(
          'This is a test notification to verify that notifications are working properly.',
          htmlFormatBigText: true,
          contentTitle: 'Test Notification',
          htmlFormatContentTitle: true,
        ),
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        0, // Use 0 as the ID for test notification
        'Test Notification',
        'This is a test notification to verify that notifications are working properly.',
        details,
      );
      print('✅ Test notification shown');
    } catch (e) {
      print('❌ Failed to show test notification: $e');
    }
  }

  Future<void> scheduleBudgetNotification(Category category) async {
    try {
      if (category.budget == null) return;

      // Check if we have notification permissions
      final hasPermissions = await checkPermissions();
      if (!hasPermissions) {
        print('⚠️ Notification permissions not granted, requesting...');
        final granted = await requestPermissions();
        if (!granted) {
          print(
              '❌ Cannot schedule budget notification: permissions not granted');
          return;
        }
      }

      // Get current month's transactions for this category
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      // Calculate total spent
      final transactionsResult =
          await _transactionRepository.getTransactionsByDateRange(
        startOfMonth,
        endOfMonth,
        await _getUserId(),
      );

      final totalSpent = transactionsResult.fold(
        (failure) => 0.0,
        (transactions) => transactions
            .where((t) => t.categoryId == category.id && t.type == 'Expense')
            .fold(0.0, (sum, t) => sum + t.amount),
      );

      // Check if budget is exceeded
      if (totalSpent > category.budget!) {
        await _showBudgetExceededNotification(category, totalSpent);
      }

      // Check if 10% of budget is left
      final remainingBudget = category.budget! - totalSpent;
      final tenPercentOfBudget = category.budget! * 0.1;

      if (remainingBudget <= tenPercentOfBudget && remainingBudget > 0) {
        await _showLowBudgetNotification(category, remainingBudget);
      }
    } catch (e) {
      print('❌ Error in scheduleBudgetNotification: $e');
    }
  }

  Future<void> _showBudgetExceededNotification(
      Category category, double totalSpent) async {
    final androidDetails = AndroidNotificationDetails(
      'budget_channel',
      'Budget Notifications',
      channelDescription: 'Notifications for budget alerts',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(
        'You have exceeded your budget for ${category.name}!\nTotal spent: ${totalSpent.toStringAsFixed(2)}',
        htmlFormatBigText: true,
        contentTitle: 'Budget Exceeded',
        htmlFormatContentTitle: true,
      ),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      'budget_exceeded_${category.id}'.hashCode,
      'Budget Exceeded',
      'You have exceeded your budget for ${category.name}!\nTotal spent: ${totalSpent.toStringAsFixed(2)}',
      details,
    );
  }

  Future<void> _showLowBudgetNotification(
      Category category, double remainingBudget) async {
    final androidDetails = AndroidNotificationDetails(
      'budget_channel',
      'Budget Notifications',
      channelDescription: 'Notifications for budget alerts',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(
        'You have only ${remainingBudget.toStringAsFixed(2)} left in your ${category.name} budget!',
        htmlFormatBigText: true,
        contentTitle: 'Low Budget Alert',
        htmlFormatContentTitle: true,
      ),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      'low_budget_${category.id}'.hashCode,
      'Low Budget Alert',
      'You have only ${remainingBudget.toStringAsFixed(2)} left in your ${category.name} budget!',
      details,
    );
  }
}
