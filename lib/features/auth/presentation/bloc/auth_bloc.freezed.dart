// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SignInImplCopyWith<$Res> {
  factory _$$SignInImplCopyWith(
          _$SignInImpl value, $Res Function(_$SignInImpl) then) =
      __$$SignInImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$SignInImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SignInImpl>
    implements _$$SignInImplCopyWith<$Res> {
  __$$SignInImplCopyWithImpl(
      _$SignInImpl _value, $Res Function(_$SignInImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$SignInImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SignInImpl implements SignIn {
  const _$SignInImpl({required this.email, required this.password});

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.signIn(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInImplCopyWith<_$SignInImpl> get copyWith =>
      __$$SignInImplCopyWithImpl<_$SignInImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return signIn(email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return signIn?.call(email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (signIn != null) {
      return signIn(email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return signIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return signIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (signIn != null) {
      return signIn(this);
    }
    return orElse();
  }
}

abstract class SignIn implements AuthEvent {
  const factory SignIn(
      {required final String email,
      required final String password}) = _$SignInImpl;

  String get email;
  String get password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignInImplCopyWith<_$SignInImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignOutImplCopyWith<$Res> {
  factory _$$SignOutImplCopyWith(
          _$SignOutImpl value, $Res Function(_$SignOutImpl) then) =
      __$$SignOutImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignOutImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SignOutImpl>
    implements _$$SignOutImplCopyWith<$Res> {
  __$$SignOutImplCopyWithImpl(
      _$SignOutImpl _value, $Res Function(_$SignOutImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignOutImpl implements SignOut {
  const _$SignOutImpl();

  @override
  String toString() {
    return 'AuthEvent.signOut()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignOutImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return signOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return signOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return signOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return signOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut(this);
    }
    return orElse();
  }
}

abstract class SignOut implements AuthEvent {
  const factory SignOut() = _$SignOutImpl;
}

/// @nodoc
abstract class _$$CheckAuthStatusImplCopyWith<$Res> {
  factory _$$CheckAuthStatusImplCopyWith(_$CheckAuthStatusImpl value,
          $Res Function(_$CheckAuthStatusImpl) then) =
      __$$CheckAuthStatusImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckAuthStatusImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$CheckAuthStatusImpl>
    implements _$$CheckAuthStatusImplCopyWith<$Res> {
  __$$CheckAuthStatusImplCopyWithImpl(
      _$CheckAuthStatusImpl _value, $Res Function(_$CheckAuthStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckAuthStatusImpl implements CheckAuthStatus {
  const _$CheckAuthStatusImpl();

  @override
  String toString() {
    return 'AuthEvent.checkAuthStatus()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckAuthStatusImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return checkAuthStatus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return checkAuthStatus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return checkAuthStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return checkAuthStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus(this);
    }
    return orElse();
  }
}

abstract class CheckAuthStatus implements AuthEvent {
  const factory CheckAuthStatus() = _$CheckAuthStatusImpl;
}

/// @nodoc
abstract class _$$SignUpImplCopyWith<$Res> {
  factory _$$SignUpImplCopyWith(
          _$SignUpImpl value, $Res Function(_$SignUpImpl) then) =
      __$$SignUpImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String firstName, String lastName, String email, String password});
}

/// @nodoc
class __$$SignUpImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SignUpImpl>
    implements _$$SignUpImplCopyWith<$Res> {
  __$$SignUpImplCopyWithImpl(
      _$SignUpImpl _value, $Res Function(_$SignUpImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$SignUpImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SignUpImpl implements SignUp {
  const _$SignUpImpl(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.signUp(firstName: $firstName, lastName: $lastName, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, email, password);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpImplCopyWith<_$SignUpImpl> get copyWith =>
      __$$SignUpImplCopyWithImpl<_$SignUpImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return signUp(firstName, lastName, email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return signUp?.call(firstName, lastName, email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (signUp != null) {
      return signUp(firstName, lastName, email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return signUp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return signUp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (signUp != null) {
      return signUp(this);
    }
    return orElse();
  }
}

abstract class SignUp implements AuthEvent {
  const factory SignUp(
      {required final String firstName,
      required final String lastName,
      required final String email,
      required final String password}) = _$SignUpImpl;

  String get firstName;
  String get lastName;
  String get email;
  String get password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignUpImplCopyWith<_$SignUpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateUserImplCopyWith<$Res> {
  factory _$$UpdateUserImplCopyWith(
          _$UpdateUserImpl value, $Res Function(_$UpdateUserImpl) then) =
      __$$UpdateUserImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});
}

/// @nodoc
class __$$UpdateUserImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$UpdateUserImpl>
    implements _$$UpdateUserImplCopyWith<$Res> {
  __$$UpdateUserImplCopyWithImpl(
      _$UpdateUserImpl _value, $Res Function(_$UpdateUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$UpdateUserImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

class _$UpdateUserImpl implements UpdateUser {
  const _$UpdateUserImpl({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'AuthEvent.updateUser(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserImplCopyWith<_$UpdateUserImpl> get copyWith =>
      __$$UpdateUserImplCopyWithImpl<_$UpdateUserImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return updateUser(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return updateUser?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (updateUser != null) {
      return updateUser(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return updateUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return updateUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (updateUser != null) {
      return updateUser(this);
    }
    return orElse();
  }
}

abstract class UpdateUser implements AuthEvent {
  const factory UpdateUser({required final User user}) = _$UpdateUserImpl;

  User get user;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserImplCopyWith<_$UpdateUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChangePasswordImplCopyWith<$Res> {
  factory _$$ChangePasswordImplCopyWith(_$ChangePasswordImpl value,
          $Res Function(_$ChangePasswordImpl) then) =
      __$$ChangePasswordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String currentPassword, String newPassword});
}

/// @nodoc
class __$$ChangePasswordImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$ChangePasswordImpl>
    implements _$$ChangePasswordImplCopyWith<$Res> {
  __$$ChangePasswordImplCopyWithImpl(
      _$ChangePasswordImpl _value, $Res Function(_$ChangePasswordImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_$ChangePasswordImpl(
      currentPassword: null == currentPassword
          ? _value.currentPassword
          : currentPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChangePasswordImpl implements ChangePassword {
  const _$ChangePasswordImpl(
      {required this.currentPassword, required this.newPassword});

  @override
  final String currentPassword;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'AuthEvent.changePassword(currentPassword: $currentPassword, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePasswordImpl &&
            (identical(other.currentPassword, currentPassword) ||
                other.currentPassword == currentPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPassword, newPassword);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePasswordImplCopyWith<_$ChangePasswordImpl> get copyWith =>
      __$$ChangePasswordImplCopyWithImpl<_$ChangePasswordImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return changePassword(currentPassword, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return changePassword?.call(currentPassword, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (changePassword != null) {
      return changePassword(currentPassword, newPassword);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return changePassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return changePassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (changePassword != null) {
      return changePassword(this);
    }
    return orElse();
  }
}

abstract class ChangePassword implements AuthEvent {
  const factory ChangePassword(
      {required final String currentPassword,
      required final String newPassword}) = _$ChangePasswordImpl;

  String get currentPassword;
  String get newPassword;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangePasswordImplCopyWith<_$ChangePasswordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetPasswordImplCopyWith<$Res> {
  factory _$$ResetPasswordImplCopyWith(
          _$ResetPasswordImpl value, $Res Function(_$ResetPasswordImpl) then) =
      __$$ResetPasswordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String token, String newPassword});
}

/// @nodoc
class __$$ResetPasswordImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$ResetPasswordImpl>
    implements _$$ResetPasswordImplCopyWith<$Res> {
  __$$ResetPasswordImplCopyWithImpl(
      _$ResetPasswordImpl _value, $Res Function(_$ResetPasswordImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? newPassword = null,
  }) {
    return _then(_$ResetPasswordImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ResetPasswordImpl implements ResetPassword {
  const _$ResetPasswordImpl({required this.token, required this.newPassword});

  @override
  final String token;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'AuthEvent.resetPassword(token: $token, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, newPassword);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordImplCopyWith<_$ResetPasswordImpl> get copyWith =>
      __$$ResetPasswordImplCopyWithImpl<_$ResetPasswordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return resetPassword(token, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return resetPassword?.call(token, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (resetPassword != null) {
      return resetPassword(token, newPassword);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return resetPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return resetPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (resetPassword != null) {
      return resetPassword(this);
    }
    return orElse();
  }
}

abstract class ResetPassword implements AuthEvent {
  const factory ResetPassword(
      {required final String token,
      required final String newPassword}) = _$ResetPasswordImpl;

  String get token;
  String get newPassword;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordImplCopyWith<_$ResetPasswordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ForgotPasswordImplCopyWith<$Res> {
  factory _$$ForgotPasswordImplCopyWith(_$ForgotPasswordImpl value,
          $Res Function(_$ForgotPasswordImpl) then) =
      __$$ForgotPasswordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ForgotPasswordImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$ForgotPasswordImpl>
    implements _$$ForgotPasswordImplCopyWith<$Res> {
  __$$ForgotPasswordImplCopyWithImpl(
      _$ForgotPasswordImpl _value, $Res Function(_$ForgotPasswordImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$ForgotPasswordImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ForgotPasswordImpl implements ForgotPassword {
  const _$ForgotPasswordImpl({required this.email});

  @override
  final String email;

  @override
  String toString() {
    return 'AuthEvent.forgotPassword(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordImplCopyWith<_$ForgotPasswordImpl> get copyWith =>
      __$$ForgotPasswordImplCopyWithImpl<_$ForgotPasswordImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) signIn,
    required TResult Function() signOut,
    required TResult Function() checkAuthStatus,
    required TResult Function(
            String firstName, String lastName, String email, String password)
        signUp,
    required TResult Function(User user) updateUser,
    required TResult Function(String currentPassword, String newPassword)
        changePassword,
    required TResult Function(String token, String newPassword) resetPassword,
    required TResult Function(String email) forgotPassword,
  }) {
    return forgotPassword(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? signIn,
    TResult? Function()? signOut,
    TResult? Function()? checkAuthStatus,
    TResult? Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult? Function(User user)? updateUser,
    TResult? Function(String currentPassword, String newPassword)?
        changePassword,
    TResult? Function(String token, String newPassword)? resetPassword,
    TResult? Function(String email)? forgotPassword,
  }) {
    return forgotPassword?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? signIn,
    TResult Function()? signOut,
    TResult Function()? checkAuthStatus,
    TResult Function(
            String firstName, String lastName, String email, String password)?
        signUp,
    TResult Function(User user)? updateUser,
    TResult Function(String currentPassword, String newPassword)?
        changePassword,
    TResult Function(String token, String newPassword)? resetPassword,
    TResult Function(String email)? forgotPassword,
    required TResult orElse(),
  }) {
    if (forgotPassword != null) {
      return forgotPassword(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignIn value) signIn,
    required TResult Function(SignOut value) signOut,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignUp value) signUp,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(ForgotPassword value) forgotPassword,
  }) {
    return forgotPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignIn value)? signIn,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignUp value)? signUp,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(ForgotPassword value)? forgotPassword,
  }) {
    return forgotPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignIn value)? signIn,
    TResult Function(SignOut value)? signOut,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignUp value)? signUp,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(ForgotPassword value)? forgotPassword,
    required TResult orElse(),
  }) {
    if (forgotPassword != null) {
      return forgotPassword(this);
    }
    return orElse();
  }
}

abstract class ForgotPassword implements AuthEvent {
  const factory ForgotPassword({required final String email}) =
      _$ForgotPasswordImpl;

  String get email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordImplCopyWith<_$ForgotPasswordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AuthState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'AuthState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements AuthState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$AuthenticatedImplCopyWith<$Res> {
  factory _$$AuthenticatedImplCopyWith(
          _$AuthenticatedImpl value, $Res Function(_$AuthenticatedImpl) then) =
      __$$AuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});
}

/// @nodoc
class __$$AuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedImpl>
    implements _$$AuthenticatedImplCopyWith<$Res> {
  __$$AuthenticatedImplCopyWithImpl(
      _$AuthenticatedImpl _value, $Res Function(_$AuthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthenticatedImpl(
      null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

class _$AuthenticatedImpl implements _Authenticated {
  const _$AuthenticatedImpl(this.user);

  @override
  final User user;

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      __$$AuthenticatedImplCopyWithImpl<_$AuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return authenticated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return authenticated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class _Authenticated implements AuthState {
  const factory _Authenticated(final User user) = _$AuthenticatedImpl;

  User get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthenticatedImplCopyWith<$Res> {
  factory _$$UnauthenticatedImplCopyWith(_$UnauthenticatedImpl value,
          $Res Function(_$UnauthenticatedImpl) then) =
      __$$UnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$UnauthenticatedImpl>
    implements _$$UnauthenticatedImplCopyWith<$Res> {
  __$$UnauthenticatedImplCopyWithImpl(
      _$UnauthenticatedImpl _value, $Res Function(_$UnauthenticatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnauthenticatedImpl implements _Unauthenticated {
  const _$UnauthenticatedImpl();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class _Unauthenticated implements AuthState {
  const factory _Unauthenticated() = _$UnauthenticatedImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements AuthState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PasswordChangedImplCopyWith<$Res> {
  factory _$$PasswordChangedImplCopyWith(_$PasswordChangedImpl value,
          $Res Function(_$PasswordChangedImpl) then) =
      __$$PasswordChangedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PasswordChangedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$PasswordChangedImpl>
    implements _$$PasswordChangedImplCopyWith<$Res> {
  __$$PasswordChangedImplCopyWithImpl(
      _$PasswordChangedImpl _value, $Res Function(_$PasswordChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PasswordChangedImpl implements _PasswordChanged {
  const _$PasswordChangedImpl();

  @override
  String toString() {
    return 'AuthState.passwordChanged()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PasswordChangedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return passwordChanged();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return passwordChanged?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return passwordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return passwordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(this);
    }
    return orElse();
  }
}

abstract class _PasswordChanged implements AuthState {
  const factory _PasswordChanged() = _$PasswordChangedImpl;
}

/// @nodoc
abstract class _$$PasswordResetImplCopyWith<$Res> {
  factory _$$PasswordResetImplCopyWith(
          _$PasswordResetImpl value, $Res Function(_$PasswordResetImpl) then) =
      __$$PasswordResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PasswordResetImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$PasswordResetImpl>
    implements _$$PasswordResetImplCopyWith<$Res> {
  __$$PasswordResetImplCopyWithImpl(
      _$PasswordResetImpl _value, $Res Function(_$PasswordResetImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PasswordResetImpl implements _PasswordReset {
  const _$PasswordResetImpl();

  @override
  String toString() {
    return 'AuthState.passwordReset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PasswordResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return passwordReset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return passwordReset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (passwordReset != null) {
      return passwordReset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return passwordReset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return passwordReset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (passwordReset != null) {
      return passwordReset(this);
    }
    return orElse();
  }
}

abstract class _PasswordReset implements AuthState {
  const factory _PasswordReset() = _$PasswordResetImpl;
}

/// @nodoc
abstract class _$$UserUpdatedImplCopyWith<$Res> {
  factory _$$UserUpdatedImplCopyWith(
          _$UserUpdatedImpl value, $Res Function(_$UserUpdatedImpl) then) =
      __$$UserUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});
}

/// @nodoc
class __$$UserUpdatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$UserUpdatedImpl>
    implements _$$UserUpdatedImplCopyWith<$Res> {
  __$$UserUpdatedImplCopyWithImpl(
      _$UserUpdatedImpl _value, $Res Function(_$UserUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$UserUpdatedImpl(
      null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

class _$UserUpdatedImpl implements _UserUpdated {
  const _$UserUpdatedImpl(this.user);

  @override
  final User user;

  @override
  String toString() {
    return 'AuthState.userUpdated(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserUpdatedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserUpdatedImplCopyWith<_$UserUpdatedImpl> get copyWith =>
      __$$UserUpdatedImplCopyWithImpl<_$UserUpdatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(User user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordChanged,
    required TResult Function() passwordReset,
    required TResult Function(User user) userUpdated,
  }) {
    return userUpdated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordChanged,
    TResult? Function()? passwordReset,
    TResult? Function(User user)? userUpdated,
  }) {
    return userUpdated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(User user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordChanged,
    TResult Function()? passwordReset,
    TResult Function(User user)? userUpdated,
    required TResult orElse(),
  }) {
    if (userUpdated != null) {
      return userUpdated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Error value) error,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return userUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Error value)? error,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_UserUpdated value)? userUpdated,
  }) {
    return userUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Error value)? error,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (userUpdated != null) {
      return userUpdated(this);
    }
    return orElse();
  }
}

abstract class _UserUpdated implements AuthState {
  const factory _UserUpdated(final User user) = _$UserUpdatedImpl;

  User get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserUpdatedImplCopyWith<_$UserUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
