import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations == null) {
      return AppLocalizations(const Locale('en'));
    }
    return localizations;
  }

  String get(String key) {
    final localizedMap = _localizedValues[locale.languageCode];
    final fallbackMap = _localizedValues['en'];

    if (localizedMap != null && localizedMap.containsKey(key)) {
      return localizedMap[key]!;
    } else if (fallbackMap != null && fallbackMap.containsKey(key)) {
      return fallbackMap[key]!;
    } else {
      return key; // Optionally return key itself if missing in all
    }
  }

  static const _localizedValues = {
    'en': {
      // Common
      'app_name': 'Expense Tracker',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'retry': 'Retry',
      'confirm': 'Confirm',
      'back': 'Back',
      'next': 'Next',
      'done': 'Done',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'no_data': 'No data available',
      'no_internet': 'No internet connection',
      'try_again': 'Please try again',
      'there': 'there',
      'add_first_transaction': 'Add your first transaction',

      // Navigation
      'nav_home': 'Home',
      'nav_transactions': 'Transactions',
      'nav_categories': 'Categories',
      'nav_profile': 'Profile',

      // Greetings
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',

      // Home Page
      'financial_overview': 'Here\'s your financial overview',
      'total_balance': 'Total Balance',
      'income': 'Income',
      'expenses': 'Expenses',
      'savings': 'Savings',
      'recent_transactions': 'Recent Transactions',
      'no_transactions': 'No transactions yet',
      'monthly_trend': 'Monthly Trend',
      'income_trend': 'Income Trend',
      'expense_trend': 'Expense Trend',
      'savings_trend': 'Savings Trend',
      'this_month': 'This Month',
      'last_month': 'Last Month',
      'trend_up': 'Trending Up',
      'trend_down': 'Trending Down',
      'trend_stable': 'Stable',
      'percentage_change': '{percentage}% {direction} from last month',
      'financial_health': 'Financial Health',
      'top_spending_category': 'Top spending category',
      'savings_rate': 'Savings Rate',
      'spending_by_category': 'Spending by Category',
      'income_by_category': 'Income by Category',
      'view_all': 'View All',
      'trend_analysis': 'Trend Analysis',
      'excellent_savings_rate':
          'Excellent savings rate! Keep up the good work.',
      'good_savings_rate': 'Good savings rate. Consider increasing it to 20%.',
      'try_increase_savings_rate':
          'Try to increase your savings rate to at least 10%.',
      'expenses_exceed_income':
          'Your expenses exceed your income. Review your spending.',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': 'Don\'t have an account?',
      'already_have_account': 'Already have an account?',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'sign_out': 'Sign Out',
      'guest_mode': 'Continue as Guest',
      'remember_me': 'Remember Me',
      'reset_password': 'Reset Password',
      'password_reset_sent': 'Password reset email sent',
      'password_reset_sent_message':
          'Password reset instructions have been sent to your email. Please check your inbox and follow the instructions.',
      'password_reset_success': 'Password reset successful',
      'password_reset_error': 'Failed to reset password',
      'invalid_email': 'Invalid email address',
      'invalid_password': 'Password must be at least 6 characters',
      'passwords_dont_match': 'Passwords do not match',
      'login_error': 'Invalid email or password',
      'register_error': 'Failed to create account',
      'email_in_use': 'Email already in use',
      'enter_first_name': 'Enter your first name',
      'enter_last_name': 'Enter your last name',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      'enter_confirm_password': 'Confirm your password',
      'email_required': 'Please enter your email',
      'password_required': 'Please enter your password',
      'confirm_password_required': 'Please confirm your password',
      'first_name_required': 'Please enter your first name',
      'last_name_required': 'Please enter your last name',
      'accept_terms': 'I accept the Terms and Conditions',
      'open_email_app': 'Open Email App',
      'send_reset_link': 'Send Reset Link',
      'forgot_password_message':
          'Enter your email address and we\'ll send you a link to reset your password.',
      'sign_up_success_title': 'Account Created!',
      'sign_up_success_message':
          'Your account was created successfully. Please verify your email to activate your account.',
      'verify_email_now': 'Verify Email Now',
      'enter_the_6_digit_code': 'Enter the 6-digit code sent to your email',
      'verify': 'Verify',
      'resend_code': 'Resend Code',
      'email_verification_success_title': 'Email Verified!',
      'email_verification_success_message':
          'Your email has been verified successfully.',
      'email_verification_success_submessage':
          'You can now log in to your account.',
      'go_to_sign_in': 'Go to Sign In',

      // Profile
      'profile': 'Profile',
      'language': 'Language',
      'currency': 'Currency',
      'settings': 'Settings',
      'logout': 'Logout',
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_new_password': 'Confirm New Password',
      'profile_picture': 'Profile Picture',
      'take_photo': 'Take Photo',
      'choose_photo': 'Choose from Gallery',
      'remove_photo': 'Remove Photo',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'phone': 'Phone Number',
      'address': 'Address',
      'bio': 'Bio',
      'notifications': 'Notifications',
      'dark_mode': 'Dark Mode',
      'system_theme': 'System Theme',
      'light_theme': 'Light Theme',
      'dark_theme': 'Dark Theme',

      // Expenses
      'expense_type': 'Expense',
      'income_type': 'Income',
      'transfer': 'Transfer',
      'recurring': 'Recurring',
      'one_time': 'One Time',
      'daily': 'Daily',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'yearly': 'Yearly',
      'start_date': 'Start Date',
      'end_date': 'End Date',
      'frequency': 'Frequency',
      'total_expenses': 'Total Expenses',
      'total_income': 'Total Income',
      'net_balance': 'Net Balance',

      // Categories
      'food': 'Food',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'bills': 'Bills',
      'entertainment': 'Entertainment',
      'health': 'Health',
      'education': 'Education',
      'other': 'Other',
      'add_category': 'Add Category',
      'edit_category': 'Edit Category',
      'delete_category': 'Delete Category',
      'category_name': 'Category Name',
      'enter_category_name': 'Enter category name',
      'category_name_required': 'Please enter a category name',
      'delete_category_confirmation': 'Are you sure you want to delete {name}?',
      'budget': 'Budget',
      'enter_budget': 'Enter budget amount',
      'description': 'Description',

      // Messages
      'profile_updated': 'Profile updated successfully',
      'language_updated': 'Language updated successfully',
      'currency_updated': 'Currency updated successfully',
      'expense_added': 'Expense added successfully',
      'income_added': 'Income added successfully',
      'transaction_deleted': 'Transaction deleted successfully',
      'category_added': 'Category added successfully',
      'category_updated': 'Category updated successfully',
      'category_deleted': 'Category deleted successfully',
      'password_changed': 'Password changed successfully',
      'settings_updated': 'Settings updated successfully',
      'changes_saved': 'Changes saved successfully',
      'error_occurred': 'An error occurred',
      'try_again_later': 'Please try again later',
      'operation_failed': 'Operation failed',
      'network_error': 'Network error',
      'server_error': 'Server error',
      'validation_error': 'Please check your input',
      'required_field': 'This field is required',
      'invalid_input': 'Invalid input',
      'success_message': 'Operation completed successfully',

      // Profile Page
      'account_settings': 'Account Settings',
      'preferences': 'Preferences',
      'appearance': 'Appearance',
      'logout_confirmation': 'Are you sure you want to logout?',
      "export_data": "Export Data",
      "export_data_description":
          "Export your transaction data in various formats",
      "export_as_csv": "Export as CSV",
      "export_as_excel": "Export as Excel",
      "export_as_pdf": "Export as PDF",
      "preparing_export": "Preparing export...",
      "export_completed": "Export completed successfully",
      "permission_required": "Permission Required",
      "permission_message":
          "Storage permission is required to export data. Please grant permission in app settings.",
      "open_settings": "Open Settings",
      "error_exporting": "Error exporting data: {error}",
      "currency_dialog_title": "Currency Settings",

      // Currency Names
      'currency_birr': 'Ethiopian Birr',
      'currency_usd': 'US Dollar',
      'currency_eur': 'Euro',
      'currency_gbp': 'British Pound',
      'currency_jpy': 'Japanese Yen',
      'currency_inr': 'Indian Rupee',
      'currency_cny': 'Chinese Yuan',
      'close': 'Close',
      'press_back_again_to_exit': 'Press back again to exit',

      // Edit Profile Dialog
      'image_pick_error': 'Failed to pick image',
      'profile_update_error': 'Error updating profile:',
      'dismiss': 'Dismiss',

      // Category Errors
      'category_id_required': 'Category ID is required',
      'category_not_found': 'Category not found',
      'cannot_update_default': 'Cannot update default categories',
      'cannot_delete_default': 'Cannot delete default categories',
      'server_failure': 'Server failure',
      'cache_failure': 'Cache failure',
      'unexpected_error': 'Unexpected error',

      // Category Remote Data Source Errors
      'failed_to_save_category': 'Failed to save category',
      'failed_to_get_category': 'Failed to get category',
      'failed_to_get_categories': 'Failed to get categories',
      'failed_to_update_category': 'Failed to update category',
      'failed_to_delete_category': 'Failed to delete category',
      'failed_to_get_categories_by_type': 'Failed to get categories by type',

      // Category Repository Errors
      'no_internet_connection': 'No internet connection',
      'category_not_found_cache': 'Category not found in local storage',
      'failed_to_cache_category': 'Failed to cache category',
      'failed_to_cache_categories': 'Failed to cache categories',
      'failed_to_get_remote_category': 'Failed to get remote category',
      'failed_to_add_remote_category': 'Failed to add remote category',
      'failed_to_update_remote_category': 'Failed to update remote category',

      // Add Transaction Page
      'add_transaction': 'Add Transaction',
      'title': 'Title',
      'enter_amount': 'Enter Amount',
      'select_category': 'Select Category',
      'no_categories': 'No categories available',
      'date': 'Date',
      'time': 'Time',
      'no_description': 'No description',

      // Edit Transaction Page
      'edit_transaction': 'Edit Transaction',
      'update_transaction': 'Update Transaction',
      'delete_transaction': 'Delete Transaction',
      'delete_transaction_confirmation':
          'Are you sure you want to delete this transaction?',
      'transaction_updated': 'Transaction updated successfully',
      'transaction_delete_error': 'Failed to delete transaction',

      // New keys
      'default_amount': 'Default Amount',
      'enter_default_amount': 'Enter default amount',
      'default_amount_required':
          'Default amount is required for recurring transactions',
      'active': 'Active',
      'quarterly': 'Quarterly',

      // Transaction List Page
      'search_transactions': 'Search transactions',
      'filters': 'Filters',
      'clear_filters': 'Clear Filters',
      'apply_filters': 'Apply Filters',
      'type': 'Type',
      'expense': 'Expense',
      'categories': 'Categories',
      'date_range': 'Date Range',
      'no_transactions_found': 'No transactions found',
      'transaction_details': 'Transaction Details',

      // Categories Page
      'search_categories': 'Search categories',
      'no_categories_found': 'No categories found',
      'add_first_category': 'Add your first category',
      'category_details': 'Category Details',

      // Import Data
      'import_data': 'Import Data',
      'import_from_csv': 'Import from CSV',
      'import_from_excel': 'Import from Excel',
      'error_importing_csv': 'Error importing CSV: {error}',
      'error_importing_excel': 'Error importing Excel: {error}',
      'no_transactions_found_in_the_file': 'No transactions found in the file',
      'import_success': '{count} transactions imported successfully',
      'error_importing': 'Error importing file: {error}',
      'add_transaction_to_get_started': 'Add a transaction to get started',

      // Category Distribution
      'no_expenses_to_display': 'No expenses to display',
      'add_expenses_to_see_distribution':
          'Add some expenses to see your spending distribution',

      // Verification Code Sent
      'verification_code_sent_title': 'Verification Code Sent',
      'verification_code_sent_message':
          'A new verification code has been sent to your email address',
      'verification_code_sent_submessage':
          'Please check your inbox and enter the code below',
      'ok': 'OK',
    },
    'am': {
      // Common
      'app_name': 'የወጪ መከታተል',
      'cancel': 'ተው',
      'save': 'አስቀምጥ',
      'delete': 'ሰርዝ',
      'edit': 'አርትዕ',
      'error': 'ስህተት',
      'success': 'ተሳክቷል',
      'loading': 'በመጫን ላይ...',
      'retry': 'እንደገና ይሞከሩ',
      'confirm': 'አረጋግጥ',
      'back': 'ተመለስ',
      'next': 'ቀጣይ',
      'done': 'ተጠናቅቋል',
      'search': 'ፈልግ',
      'filter': 'አጣራ',
      'sort': 'ያዝዝ',
      'no_data': 'ዳሰሳ የለም',
      'no_internet': 'የኢንተርኔት ግንኙነት የለም',
      'try_again': 'እባክዎ እንደገና ይሞከሩ',
      'there': 'እዚያ',
      'add_first_transaction': 'የመጀመሪያዎን ግብይት ያክሉ',

      // Navigation
      'nav_home': 'ቤት',
      'nav_transactions': 'ግብይቶች',
      'nav_categories': 'ምድቦች',
      'nav_profile': 'መገለጫ',

      // Greetings
      'good_morning': 'እንደምን አደሩ',
      'good_afternoon': 'እንደምን አረፈዱ',
      'good_evening': 'እንደምን አመሹ',

      // Home Page
      'financial_overview': 'የገንዘብ አጠቃላይ እይታዎ',
      'total_balance': 'ጠቅላላ ቀሪ',
      'income': 'ገቢ',
      'expenses': 'ወጪዎች',
      'savings': 'ቁጠባ',
      'recent_transactions': 'የቅርብ ጊዜ ግብይቶች',
      'no_transactions': 'እስካሁን ምንም ግብይት የለም',
      'monthly_trend': 'ወርሃዊ አዝማሚያ',
      'income_trend': 'የገቢ አዝማሚያ',
      'expense_trend': 'የወጪ አዝማሚያ',
      'savings_trend': 'የቁጠባ አዝማሚያ',
      'this_month': 'ይህ ወር',
      'last_month': 'ባለፈው ወር',
      'trend_up': 'እየጨመረ ነው',
      'trend_down': 'እየቀነሰ ነው',
      'trend_stable': 'ቋሚ ነው',
      'percentage_change': 'ከባለፈው ወር {percentage}% {direction}',
      'financial_health': 'የገንዘብ ጤና',
      'top_spending_category': 'በጣም የተጠቀሰበት ምድብ',
      'savings_rate': 'የቁጠባ መጠን',
      'spending_by_category': 'በምድብ የሚደረገው ወጪ',
      'income_by_category': 'በምድብ የሚገኘው ገቢ',
      'view_all': 'ሁሉንም ይመልከቱ',
      'trend_analysis': 'የአዝማሚያ ትንታኔ',
      'excellent_savings_rate': 'በጣም ጥሩ የቁጠባ መጠን! እንዲህ ቀጥሉ።',
      'good_savings_rate': 'ጥሩ የቁጠባ መጠን። ወደ 20% ማድረስ ይሞክሩ።',
      'try_increase_savings_rate': 'የቁጠባዎን መጠን ቢያንስ 10% ያድሱ።',
      'expenses_exceed_income': 'ወጪዎ ከገቢዎ በላይ ነው። ወጪዎን ይመርምሩ።',

      // Auth
      'login': 'ግባ',
      'register': 'ይመዝገቡ',
      'email': 'ኢሜይል',
      'password': 'የይለፍ ቃል',
      'confirm_password': 'የይለፍ ቃል አረጋግጥ',
      'forgot_password': 'የይለፍ ቃልዎን ረሱ?',
      'dont_have_account': 'መለያ የላችሁም?',
      'already_have_account': 'አስቀድመው መለያ አላችሁ?',
      'sign_in': 'ግባ',
      'sign_up': 'ይመዝገቡ',
      'sign_out': 'ውጣ',
      'guest_mode': 'እንደ እንግድ ይቀጥሉ',
      'remember_me': 'አስታውሰኝ',
      'reset_password': 'የይለፍ ቃል ዳግም ያዘጋጁ',
      'password_reset_sent': 'የይለፍ ቃል ዳግም የማዘጋጃ ኢሜይል ተልኳል',
      'password_reset_sent_message':
          'የይለፍ ቃል ዳግም የማዘጋጃ መመሪያዎች ወደ ኢሜይልዎ ተልከዋል። እባክዎ የገቢ ሳጥንዎን ያረጋግጡ እና መመሪያዎቹን ይከተሉ።',
      'password_reset_success': 'የይለፍ ቃል በተሳክቶ ተዘጋጅቷል',
      'password_reset_error': 'የይለፍ ቃል እንደገና ማዘጋጀት አልተሳካም',
      'invalid_email': 'ልክ ያልሆነ ኢሜይል አድራሻ',
      'invalid_password': 'የይለፍ ቃል ቢያንስ 6 ቁምፊ መሆን አለበት',
      'passwords_dont_match': 'የይለፍ ቃሎች አይጣጣሙም',
      'login_error': 'ልክ ያልሆነ ኢሜይል ወይም የይለፍ ቃል',
      'register_error': 'መለያ መፍጠር አልተሳካም',
      'email_in_use': 'ኢሜይል አስቀድሞ ተጠቅሟል',
      'enter_first_name': 'የመጀመሪያ ስምዎን ያስገቡ',
      'enter_last_name': 'የአያት ስምዎን ያስገቡ',
      'enter_email': 'ኢሜይልዎን ያስገቡ',
      'enter_password': 'የይለፍ ቃልዎን ያስገቡ',
      'enter_confirm_password': 'የይለፍ ቃልዎን ያረጋግጡ',
      'email_required': 'እባክዎ ኢሜይልዎን ያስገቡ',
      'password_required': 'እባክዎ የይለፍ ቃልዎን ያስገቡ',
      'confirm_password_required': 'እባክዎ የይለፍ ቃልዎን ያረጋግጡ',
      'first_name_required': 'እባክዎ የመጀመሪያ ስምዎን ያስገቡ',
      'last_name_required': 'እባክዎ የአያት ስምዎን ያስገቡ',
      'accept_terms': 'የአገልግሎት ውሎችን እቀበላለሁ',
      'open_email_app': 'ኢሜይል መተግበሪያ ክፈት',
      'forgot_password_message':
          'ኢሜይል አድራሻዎን ያስገቡ እና የይለፍ ቃልዎን ለማዘጋጀት አገናኝ እንልካለን።',
      'sign_up_success_title': 'መለያዎ ተፈጥሯል!',
      "sign_up_success_message":
          "መለያዎ በተሳካ ሁኔታ ተፈጥሯል። መለያዎን ለማንቃት እባክዎን ኢሜይልዎን ያረጋግጡ።",
      "verify_email_now": "ኢሜይል ያረጋግጡ",
      "continue": "ቀጥል",
      "success_message": "በተሳካ ሁኔታ ተጠናቅቋል!",
      "enter_the_6_digit_code": "ወደ ኢሜይልዎ የተላከውን 6-አሃዝ ኮድ ያስገቡ",
      "verify": "ያረጋግጡ",
      "resend_code": "ኮድ ዳግም ላክ",
      "email_verification_success_title": "ኢሜይል ተፈጥሯል!",
      "email_verification_success_message": "ኢሜይልዎ በተሳካ ሁኔታ ተፈጥሯል።",
      "email_verification_success_submessage":
          "መለያዎን ለማንቃት እባክዎን ኢሜይልዎን ያረጋግጡ።",
      'go_to_sign_in': 'ግባ ይጀምሩ',

      // Profile
      'profile': 'መገለጫ',
      'language': 'ቋንቋ',
      'currency': 'ምንዛሪ',
      'settings': 'ቅንብሮች',
      'logout': 'ውጣ',
      'edit_profile': 'መገለጫ አርትዕ',
      'change_password': 'የይለፍ ቃል ቀይር',
      'current_password': 'አሁን ያለው የይለፍ ቃል',
      'new_password': 'አዲስ የይለፍ ቃል',
      'confirm_new_password': 'አዲሱን የይለፍ ቃል አረጋግጥ',
      'profile_picture': 'የመገለጫ ስዕል',
      'take_photo': 'ስዕል ይውሰዱ',
      'choose_photo': 'ከጋሌሪ ይምረጡ',
      'remove_photo': 'ስዕሉን ያስወግዱ',
      'first_name': 'የመጀመሪያ ስም',
      'last_name': 'የአያት ስም',
      'phone': 'ስልክ ቁጥር',
      'address': 'አድራሻ',
      'bio': 'ታሪክ',
      'notifications': 'ማስታወቂያዎች',
      'dark_mode': 'ጨለማ ሁኔታ',
      'system_theme': 'የስርዓት ገጽታ',
      'light_theme': 'ብርሃን ገጽታ',
      'dark_theme': 'ጨለማ ገጽታ',
      'currency_dialog_title': 'ምንዛሪ ምርጫ',

      // Expenses
      'expense_type': 'ወጪ',
      'income_type': 'ገቢ',
      'transfer': 'ማዛወር',
      'recurring': 'የሚደገም',
      'one_time': 'አንድ ጊዜ',
      'daily': 'በየቀኑ',
      'weekly': 'በየሳምንቱ',
      'monthly': 'በየወሩ',
      'yearly': 'በየአመቱ',
      'start_date': 'የመጀመሪያ ቀን',
      'end_date': 'የመጨረሻ ቀን',
      'frequency': 'ድግግሞሽ',
      'total_expenses': 'ጠቅላላ ወጪዎች',
      'total_income': 'ጠቅላላ ገቢ',
      'net_balance': 'የተጣራ ቀሪ',

      // Categories
      'food': 'ምግብ',
      'transport': 'መጓጓዣ',
      'shopping': 'ግዢ',
      'bills': 'ሂሳቦች',
      'entertainment': 'አዝናኝ',
      'health': 'ጤና',
      'education': 'ትምህርት',
      'other': 'ሌላ',
      'add_category': 'ምድብ አክል',
      'edit_category': 'ምድብ አርትዕ',
      'delete_category': 'ምድብ ሰርዝ',
      'category_name': 'የምድብ ስም',
      'enter_category_name': 'የምድብ ስም ያስገቡ',
      'category_name_required': 'እባክዎ የምድብ ስም ያስገቡ',
      'delete_category_confirmation': 'እርግጠኛ ነዎት {name} ን መሰረዝ እንደሚፈልጉ?',
      'budget': 'በጀት',
      'enter_budget': 'የበጀት መጠን ያስገቡ',
      'description': 'መግለጫ',

      // Messages
      'profile_updated': 'መገለጫዎ በተሳክቶ ተዘምኗል',
      'language_updated': 'ቋንቋዎ በተሳክቶ ተዘምኗል',
      'currency_updated': 'ምንዛሪዎ በተሳክቶ ተዘምኗል',
      'expense_added': 'ወጪዎ በተሳክቶ ተጨምሯል',
      'income_added': 'ገቢዎ በተሳክቶ ተጨምሯል',
      'transaction_deleted': 'ግብይቱ በተሳክቶ ተሰርዟል',
      'category_added': 'ምድቡ በተሳክቶ ተጨምሯል',
      'category_updated': 'ምድቡ በተሳክቶ ተዘምኗል',
      'category_deleted': 'ምድቡ በተሳክቶ ተሰርዟል',
      'password_changed': 'የይለፍ ቃልዎ በተሳክቶ ተቀይሯል',
      'settings_updated': 'ቅንብሮችዎ በተሳክቶ ተዘምነዋል',
      'changes_saved': 'ለውጦች በተሳክቶ ተቀምጠዋል',
      'error_occurred': 'ስህተት ተከስቷል',
      'try_again_later': 'እባክዎ በኋላ እንደገና ይሞከሩ',
      'operation_failed': 'ክወናው አልተሳካም',
      'network_error': 'የኔትወርክ ስህተት',
      'server_error': 'የሰርቨር ስህተት',
      'validation_error': 'እባክዎ ግብዣዎን ያረጋግጡ',
      'required_field': 'ይህ መስክ ያስፈልጋል',
      'invalid_input': 'ልክ ያልሆነ ግብዣ',

      // Profile Page
      'account_settings': 'የመለያ ቅንብሮች',
      'preferences': 'ምርጫዎች',
      'appearance': 'መልክ',
      'logout_confirmation': 'ለማውጣት እንደሚፈልጉ እርግጠኛ ነዎት?',
      "export_data": "መረጃ አውጣው",
      "export_data_description": "የግብይት ውሂብዎን በተለያዩ ቅርጸቶች አውጣው",
      "export_as_csv": "እንደ CSV አውጣው",
      "export_as_excel": "እንደ Excel አውጣው",
      "export_as_pdf": "እንደ PDF አውጣው",
      "preparing_export": "ለማውጣት ይዘጋጃል...",
      "export_completed": "ውጣት በተሳክቶ ተጠናቅቋል",
      "permission_required": "ፍቃድ ያስፈልጋል",
      "permission_message":
          "ውሂብን ለመውጣት የማከማቻ ፍቃድ ያስፈልጋል። እባክዎ በአፕሊኬሽን ቅንብሮች ውስጥ ፍቃድ ይስጡ።",
      "open_settings": "ቅንብሮችን ክፈት",
      "error_exporting": "ውሂብን በመውጣት ላይ ስህተት: {error}",

      // Currency Names
      'currency_birr': 'ኢትዮጵያ ብር',
      'currency_usd': 'አሜሪካ ዶላር',
      'currency_eur': 'ዩሮ',
      'currency_gbp': 'የእንግሊዝ ፓውንድ',
      'currency_jpy': 'የጃፓን የን',
      'currency_inr': 'የህንድ ሩፒ',
      'currency_cny': 'የቻይና ዩዋን',
      'close': 'ዝጋ',
      'press_back_again_to_exit': 'ለማውጣት እንደገና ይጫኑ',

      // Edit Profile Dialog
      'image_pick_error': 'ስዕል መምረጥ አልተሳካም',
      'profile_update_error': 'መገለጫ ማዘምን ስህተት:',
      'dismiss': 'ዝጋ',

      // Category Errors
      'category_id_required': 'የምድብ መታወቂያ ያስፈልጋል',
      'category_not_found': 'ምድቡ አልተገኘም',
      'cannot_update_default': 'ነባር ምድብን ማዘምን አይቻልም',
      'cannot_delete_default': 'ነባር ምድብን ማስረዝ አይቻልም',
      'server_failure': 'የሰርቨር ስህተት',
      'cache_failure': 'የኬሽ ስህተት',
      'unexpected_error': 'ያልተጠበቀ ስህተት',

      // Category Remote Data Source Errors
      'failed_to_save_category': 'ምድቡን መቀመጥ አልተሳካም',
      'failed_to_get_category': 'ምድቡን መውሰድ አልተሳካም',
      'failed_to_get_categories': 'ምድቦችን መውሰድ አልተሳካም',
      'failed_to_update_category': 'ምድቡን ማዘምን አልተሳካም',
      'failed_to_delete_category': 'ምድቡን ማስረዝ አልተሳካም',
      'failed_to_get_categories_by_type': 'በዓይነት ምድቦችን መውሰድ አልተሳካም',

      // Add Transaction Page
      'add_transaction': 'ግብይት አክል',
      'title': 'ርዕስ',
      'enter_amount': 'መጠን ያስገቡ',
      'select_category': 'ምድብ ይምረጡ',
      'no_categories': 'ምድቦች አልተገኙም',
      'date': 'ቀን',
      'time': 'ሰዓት',
      'no_description': 'መግለጫ የለም',

      // Edit Transaction Page
      'edit_transaction': 'ግብይት አርትዕ',
      'update_transaction': 'ግብይት አዘምን',
      'delete_transaction': 'ግብይት ሰርዝ',
      'delete_transaction_confirmation': 'ግብይት ሰርዝ እንደሚፈልጉ እርግጠኛ ነዎት?',
      'transaction_update_error': 'ግብይት አዘምን አልተሳካም',
      'transaction_delete_error': 'ግብይት ሰርዝ አልተሳካም',

      // Transaction List Page
      'search_transactions': 'ግብይቶችን ፈልግ',
      'filters': 'አጣራዎች',
      'clear_filters': 'አጣራዎችን ያጽዱ',
      'apply_filters': 'አጣራዎችን ይተግብሩ',
      'type': 'ዓይነት',
      'expense': 'ወጪ',
      'categories': 'ምድቦች',
      'date_range': 'የቀን ክልል',
      'no_transactions_found': 'ምንም ግብይት አልተገኘም',
      'transaction_details': 'የግብይት ዝርዝሮች',

      // Categories Page
      'search_categories': 'ምድቦችን ፈልግ',
      'no_categories_found': 'ምንም ምድብ አልተገኘም',
      'add_first_category': 'የመጀመሪያዎን ምድብ ያክሉ',
      'category_details': 'የምድብ ዝርዝሮች',

      // Import Data
      'import_data': 'መረጃ አስገባ',
      'import_from_csv': 'ከ CSV አስገባ',
      'import_from_excel': 'ከ Excel አስገባ',
      'error_importing_csv': 'CSV ን በማስገባት ላይ ስህተት: {error}',
      'error_importing_excel': 'Excel ን በማስገባት ላይ ስህተት: {error}',
      'no_transactions_found_in_the_file': 'በፋይሉ ውስጥ ምንም ግብይት አልተገኘም',
      'import_success': '{count} ግብይቶች በተሳክቶ ተገብተዋል',
      'error_importing': 'ፋይሉን በማስገባት ላይ ስህተት: {error}',
      'add_transaction_to_get_started': 'ለመጀመር ግብይት ያክሉ',

      // Category Distribution
      'no_expenses_to_display': 'ምንም ወጪዎች አልተገኙም',
      'add_expenses_to_see_distribution': 'የሚደረጉትን ወጪዎች ለማየት አንዳንድ ወጪዎችን ያክሉ',

      // Verification Code Sent
      'verification_code_sent_title': 'የማረጋገጫ ኮድ ተልኳል',
      'verification_code_sent_message': 'አዲስ የማረጋገጫ ኮድ ወደ ኢሜይል አድራሻዎ ተልኳል።',
      'verification_code_sent_submessage':
          'እባክዎ የገቢ መልእክትዎን ያረጋግጡ እና ኮዱን ከዚህ በታች ያስገቡ',
      'ok': 'እሺ',
    }
  };
}
