part of 'singup_cubit.dart';

@immutable
sealed class SingupState {}

final class SingupInitial extends SingupState {}
class SignupLoading extends SingupState {}

class SignupSuccess extends SingupState {}

class SignupFailure extends SingupState {
  final String error;

  SignupFailure({required this.error});
}
