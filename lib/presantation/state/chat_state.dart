
import 'package:dash_chat/dash_chat.dart';
import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/data/model/my_chat_message.dart';
import 'package:earthquake/domain/services/api_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/chat_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class ChatState extends State<ChatActivity>{
  List<ChatMessage> _messages;
  Earthquake _earthquake;
  User _user;
  IOWebSocketChannel _channel;
  ChatState(Earthquake earthquake){
    _earthquake=earthquake;
    initField();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body:
    DashChat(user: ChatUser(uid:_user.id,
        name: _user.name,
        lastName: _user.lastName ),
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
      onSend: onMessageSend,),
    appBar: AppBar(title: Text("Chat"),),);
  }


  @override
  void dispose() {
_channel.sink.close();
super.dispose();
  }

  onMessageSend(ChatMessage message ) {
    MyChatMessage myChatMessage = new MyChatMessage();
    myChatMessage.earthquakeId=_earthquake.id;
    myChatMessage.message=message.text;
    myChatMessage.id=message.id;
    myChatMessage.user=_user;
    _channel.sink.add(jsonEncode(myChatMessage.toJson()));
  }

  void initField() {
    _user = new User();
    _user.name="richard";
    _user.id="richard_kollcaku@hotmail.com";
    _user.lastName="kollcaku";
    Map<String, dynamic> headers= new Map();
    headers["earthquakeId"]=_earthquake.id;
    _channel=  IOWebSocketChannel.connect(ApiService.webSocket,headers: headers);
    _channel.stream.listen((message) {
      MyChatMessage myChatMessage = MyChatMessage.fromJson(jsonDecode(message));
      setState(() {
        _messages.add(new ChatMessage(id:myChatMessage.id,
            text: myChatMessage.message,
            createdAt:Util.getLocalDateTime(myChatMessage.createdTime),
            user: new ChatUser(uid:myChatMessage.user.id,
                name: myChatMessage.user.name,
                lastName: myChatMessage.user.lastName )));
      });


    });



    _messages = new List();

  }
}