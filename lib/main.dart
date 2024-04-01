import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat/cubits/auth%20cubit/auth_cubit.dart';
import 'package:scholar_chat/cubits/chat%20cubit/chat_cubit.dart';
import 'package:scholar_chat/firebase_options.dart';
import 'package:scholar_chat/views/chat_view.dart';
import 'package:scholar_chat/views/login_view.dart';
import 'package:scholar_chat/views/signup_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ScholarChat());
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          SignupView.id: (context) => SignupView(),
          LoginView.id: (context) => LoginView(),
          ChatView.id: (context) => ChatView(),
        },
        initialRoute: LoginView.id,
      ),
    );
  }
}
