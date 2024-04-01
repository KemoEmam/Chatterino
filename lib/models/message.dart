import 'package:scholar_chat/constants.dart';

class Message {
  String message;
  String id;

  Message(this.message, this.id);

  factory Message.fromJson(jsonData) {
    return Message(jsonData[kMessage], jsonData[kId]);
  }
}
