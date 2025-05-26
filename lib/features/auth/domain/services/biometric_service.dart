import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isBiometricsAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      final result = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Biometric error: $e');
      return false;
    }
  }

  Future<bool> shouldUseBiometrics() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      return canCheckBiometrics && availableBiometrics.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }
}
