import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/core/network/network_info_impl.dart';
import 'package:expense_tracker/core/services/hive/hive_registry.dart';
import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart';
import 'package:expense_tracker/core/services/theme/theme_service.dart';
import 'package:expense_tracker/core/presentation/bloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

@module
abstract class CoreModule {
  @singleton
  Dio get dio => Dio();

  @singleton
  @preResolve
  Future<ApiService> apiService(
    Dio dio,
    @Named('tokens') Box<String> tokenBox,
  ) async {
    return ApiService(dio, tokenBox);
  }

  @singleton
  InternetConnectionChecker connectionChecker() => InternetConnectionChecker();

  @singleton
  NetworkInfo networkInfo(InternetConnectionChecker checker) =>
      NetworkInfoImpl(checker);

  @preResolve
  @Named('users')
  Future<Box<HiveUserModel>> userBox() async {
    if (!Hive.isBoxOpen('users')) {
      await HiveRegistry.initialize();
    }
    return HiveRegistry.userBox;
  }

  @preResolve
  @Named('tokens')
  Future<Box<String>> tokenBox() async {
    if (!Hive.isBoxOpen('tokens')) {
      await HiveRegistry.initialize();
    }
    return HiveRegistry.tokenBox;
  }

  @preResolve
  @Named('preferences')
  Future<Box<bool>> preferencesBox() async {
    if (!Hive.isBoxOpen('preferences')) {
      await HiveRegistry.initialize();
    }
    return HiveRegistry.preferencesBox;
  }

  @preResolve
  Future<SharedPreferences> get sharedPreferences async =>
      await SharedPreferences.getInstance();

  @singleton
  ThemeService themeService(SharedPreferences prefs) => ThemeService(prefs);

  @singleton
  ThemeBloc themeBloc(ThemeService themeService) => ThemeBloc(themeService);

  @singleton
  AppLocalizations appLocalizations() => AppLocalizations(const Locale('en'));
}
