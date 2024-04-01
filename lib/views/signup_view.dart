import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/cubits/auth%20cubit/auth_cubit.dart';
import 'package:scholar_chat/helper/email_validation.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/views/chat_view.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_text_form_field.dart';

class SignupView extends StatelessWidget {
  static String id = 'signup_view';
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignupLoading) {
          isLoading = true;
        } else if (state is SignupSuccess) {
          Navigator.pushNamed(context, ChatView.id, arguments: email);
          isLoading = false;
        } else if (state is SignupFailure) {
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
                          "Scholar Chat",
                          style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontSize: 32,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 90),
                    const Row(
                      children: [
                        Text(
                          "REGISTER",
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
                      hintText: "Password",
                      onChanged: (data) {
                        password = data;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          emailValidation(context, email);
                          BlocProvider.of<AuthCubit>(context)
                              .signupUser(context, email!, password!);
                        }
                      },
                      label: "Register",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "  Sign In",
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
