import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class OmLocalizations {
  static const LocalizationsDelegate<MaterialLocalizations> materialDelegate =
      _OmMaterialLocalizationsDelegate();

  static const LocalizationsDelegate<CupertinoLocalizations> cupertinoDelegate =
      _OmCupertinoLocalizationsDelegate();
}

class _OmMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _OmMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'om';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final enLocalizations =
        await GlobalMaterialLocalizations.delegate.load(const Locale('en'));
    return enLocalizations;
  }

  @override
  bool shouldReload(_OmMaterialLocalizationsDelegate old) => false;
}

class _OmCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _OmCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'om';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    final enLocalizations =
        await DefaultCupertinoLocalizations.delegate.load(const Locale('en'));
    return enLocalizations;
  }

  @override
  bool shouldReload(_OmCupertinoLocalizationsDelegate old) => false;
}
