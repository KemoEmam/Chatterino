import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/cubits/auth%20cubit/auth_cubit.dart';
import 'package:scholar_chat/cubits/chat%20cubit/chat_cubit.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/views/chat_view.dart';
import 'package:scholar_chat/views/signup_view.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_text_form_field.dart';

class LoginView extends StatelessWidget {
  String? email;
  String? password;
  bool isLoading = false;
  static const String id = 'login_view';
  final GlobalKey<FormState> formKey = GlobalKey();

  LoginView({super.key, this.email, this.password});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = false;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).readMessages();
          Navigator.pushNamed(context, ChatView.id, arguments: email);
          isLoading = false;
        } else if (state is LoginFailure) {
          isLoading = false;
          showSnackBar(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Image.asset(
                      "assets/images/scholar.png",
                      scale: .9,
                      height: 100,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chatterino",
                          style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontSize: 32,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                    const Row(
                      children: [
                        Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextFormFeld(
                      onChanged: (data) {
                        email = data;
                      },
                      hintText: "Email",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormFeld(
                      obscureText: true,
                      onChanged: (data) {
                        password = data;
                      },
                      hintText: "Password",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context)
                              .signinUser(email: email!, password: password!);
                        }
                      },
                      label: "login",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignupView.id);
                          },
                          child: const Text(
                            "  Sign Up",
                            style: TextStyle(color: Color(0xffc7ede6)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
