
import 'package:dash_chat/dash_chat.dart';
import 'package:earthquake/presantation/activity/chat_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class ChatState extends State<ChatActivity>{
  List<ChatMessage> _messages;
  ChatState(){
    initField();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body:
    DashChat(user: ChatUser(name: "richard",uid: "sadfa"),
      messages: _messages,
      showUserAvatar: true,
      showInputCursor: true,
      height: Device.get().isIphoneX
          ? MediaQuery.of(context).size.height - 100
          : null,
      inputFooterBuilder: () {
        return SizedBox( height: Device.get().isIphoneX ? 34.0 : 0);
      },
      showAvatarForEveryMessage: true,
      shouldShowLoadEarlier: true,
      onSend: onSend,),
    appBar: AppBar(title: Text("Chat"),),);
  }


  onSend(ChatMessage message ) {
    _messages.add(message);
  }

  void initField() {
    _messages = new List();
    _messages.add(new ChatMessage(text: "test1", user: ChatUser(name: "paqiz",uid: "111")));
    _messages.add(new ChatMessage(text: "test2",video: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", user: ChatUser(name: "paqizz",uid: "fdsfgfs")));
    _messages.add(new ChatMessage(text: "test3",image: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", user: ChatUser(name: "jo mer", uid: "sdfsf",)));

  }
}