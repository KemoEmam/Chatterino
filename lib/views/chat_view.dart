import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/cubits/chat%20cubit/chat_cubit.dart';
import 'package:scholar_chat/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatView extends StatelessWidget {
  static const String id = 'chat_view';

  final TextEditingController controller = TextEditingController();
  final control = ScrollController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? email;
  ChatView({super.key, this.email});
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            const Text(
              'Chat',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messageList =
                    BlocProvider.of<ChatCubit>(context).messageList;
                return ListView.builder(
                  reverse: true,
                  controller: control,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    return messageList[index].id == email
                        ? ChatBubble(
                            message: messageList[index],
                          )
                        : ChatBubbleFriend(message: messageList[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(message: data, email: email.toString());
                controller.clear();
                control.animateTo(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              },
              decoration: InputDecoration(
                  hintText: 'Send Message',
                  suffixIcon: GestureDetector(
                      onTap: () async {
                        String message = controller.text;
                        if (message.isNotEmpty) {
                          BlocProvider.of<ChatCubit>(context).sendMessage(
                              message: message, email: email.toString());
                          controller.clear();
                          FocusScope.of(context).unfocus();
                          control.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut);
                        }
                      },
                      child: const Icon(Icons.send)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
