import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat/models/message.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Message? message;
  Future<void> signinUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-login-credentials') {
        emit(LoginFailure(errMessage: 'Invalid email or password.'));
      } else if (e.code == 'weak-password') {
        emit(LoginFailure(errMessage: 'The password provided is too weak'));
      } else if (e.code == 'email-already-in-use') {
        emit(LoginFailure(
            errMessage: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'An error has occured, try again later!'));
    }
  }

  Future<void> signupUser(context, String email, String password) async {
    emit(SignupLoading());
    try {
      final UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.user!.sendEmailVerification();
      emit(SignupSuccess(
          successMessage: 'Success! Check you email for a verification link.'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignupFailure(errMessage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignupFailure(
            errMessage: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(SignupFailure(errMessage: 'An error has occured, try again later!'));
    }
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
  }
}
