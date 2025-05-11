import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizationsOm {
  final Locale locale;

  AppLocalizationsOm(this.locale);

  static AppLocalizationsOm of(BuildContext context) {
    return Localizations.of<AppLocalizationsOm>(context, AppLocalizationsOm)!;
  }

  static const LocalizationsDelegate<AppLocalizationsOm> delegate =
      _AppLocalizationsOmDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('om'),
  ];

  static const Map<String, String> _localizedValues = {
    'appName': 'Expense Tracker',
    'addTransaction': 'Dabalata',
    'editTransaction': 'Jijjiiri',
    'deleteTransaction': 'Haquu',
    'amount': 'Baay\'ina',
    'description': 'Ibsa',
    'date': 'Guyyaa',
    'category': 'Kategori',
    'type': 'Gosa',
    'income': 'Argata',
    'expense': 'Baasata',
    'save': 'Kayyadi',
    'cancel': 'Dhiisi',
    'delete': 'Haquu',
    'edit': 'Jijjiiri',
    'search': 'Barbaadi',
    'filter': 'Filadhu',
    'sort': 'Qoqqoodi',
    'settings': 'Qindaawwan',
    'language': 'Afaan',
    'theme': 'Theme',
    'currency': 'Sarra',
    'profile': 'Profile',
    'logout': 'Ba\'i',
    'login': 'Seeni',
    'register': 'Galmaa\'i',
    'email': 'Email',
    'password': 'Password',
    'confirmPassword': 'Password Mirkaneessi',
    'forgotPassword': 'Password Dhabe?',
    'resetPassword': 'Password Haala',
    'name': 'Maqaa',
    'phone': 'Bilbila',
    'address': 'Teessoo',
    'city': 'Magaalaa',
    'country': 'Biiftuu',
    'zipCode': 'Zip Code',
    'submit': 'Galchi',
    'loading': 'Loading',
    'error': 'Dogoggora',
    'success': 'Milkaa\'e',
    'warning': 'Yaadachiisa',
    'info': 'Odeeffannoo',
    'noData': 'Data Hin Jiru',
    'retry': 'Irra Deebi\'i',
    'close': 'Cufi',
    'ok': 'Tole',
    'yes': 'Eeyyee',
    'no': 'Lakki',
    'confirm': 'Mirkaneessi',
    'back': 'Deebi\'i',
    'next': 'Itti Aanaa',
    'finish': 'Xumuri',
    'skip': 'Dhiisi',
    'done': 'Xumure',
    'apply': 'Fayyadami',
    'reset': 'Haala',
    'clear': 'Qulqulleessi',
    'select': 'Filadhu',
    'unselect': 'Filadhu Dhiisi',
    'selectAll': 'Hunda Filadhu',
    'unselectAll': 'Hunda Filadhu Dhiisi',
    'selectNone': 'Hin Filadhu',
    'selectSome': 'Filadhu',
    'selectFew': 'Filadhu',
    'selectMany': 'Filadhu',
    'selectOne': 'Tokko Filadhu',
    'selectMultiple': 'Filadhu',
    'selectRange': 'Filadhu',
    'selectCustom': 'Filadhu',
    'selectDefault': 'Filadhu',
    'selectRequired': 'Filadhu',
    'selectOptional': 'Filadhu',
    'selectPlaceholder': 'Filadhu',
    'selectSearchPlaceholder': 'Barbaadi',
    'selectNoResults': 'Hin Argamne',
    'selectLoading': 'Loading',
    'selectError': 'Dogoggora',
    'selectSuccess': 'Milkaa\'e',
    'selectWarning': 'Yaadachiisa',
    'selectInfo': 'Odeeffannoo',
    'selectNoData': 'Data Hin Jiru',
    'selectRetry': 'Irra Deebi\'i',
    'selectClose': 'Cufi',
    'selectOk': 'Tole',
    'selectYes': 'Eeyyee',
    'selectNo': 'Lakki',
    'selectConfirm': 'Mirkaneessi',
    'selectBack': 'Deebi\'i',
    'selectNext': 'Itti Aanaa',
    'selectFinish': 'Xumuri',
    'selectSkip': 'Dhiisi',
    'selectDone': 'Xumure',
    'selectApply': 'Fayyadami',
    'selectReset': 'Haala',
    'selectClear': 'Qulqulleessi',
  };

  String get(String key) {
    return _localizedValues[key] ?? key;
  }
}

class _AppLocalizationsOmDelegate
    extends LocalizationsDelegate<AppLocalizationsOm> {
  const _AppLocalizationsOmDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'om';

  @override
  Future<AppLocalizationsOm> load(Locale locale) async =>
      AppLocalizationsOm(locale);

  @override
  bool shouldReload(_AppLocalizationsOmDelegate old) => false;
}
