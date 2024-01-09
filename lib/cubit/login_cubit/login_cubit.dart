import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final box = GetStorage();
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoading());
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access and store UID
      final userId = userCredential.user!.uid;
      box.write("userId", userId);

      print(box.read("userId"));
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(error: e.message));
    } catch (e) {
      emit(LoginFailure(error: 'An unexpected error occurred'));
    }
  }
  Future<void> signOut() async {
    try {
      emit(LogoutLoading());
      await FirebaseAuth.instance.signOut();
      emit(LogoutSuccess());
    } catch (e) {
      print('Error signing out: $e');
      emit(LogoutFailure());
    }
  }
}
