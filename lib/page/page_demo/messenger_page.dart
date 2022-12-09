import 'package:flutter/material.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/common/widgets/mybutton.dart';
import 'package:manga_app/common/widgets/mytextfield.dart';
import 'package:manga_app/page/page_demo/socket_manager.dart';

class MessengerPage extends StatefulWidget {
  final String name;

  const MessengerPage({super.key, required this.name});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final messengerController = TextEditingController();
  var listMessenger = <String>[];
  Iterable listNew = ['a'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: "Messenger"),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        MyTextField(
          labelText: 'messenger',
          controller: messengerController,
        ),
        SizedBox(
          height: 32,
        ),
        GestureDetector(
          onTap: () {
            sendMessenger(messengerController.text);
            socketManager.connect(widget.name);
          },
          child: Container(
            alignment: Alignment.center,
            height: 32,
            width: 100,
            child: Text('Send'),
            color: Colors.green,
          ),
        ),
        Expanded(
          child: buildListMessenger(listMessenger),
        ),
      ],
    );
  }

  Widget buildListMessenger(List<String> listMessenger) {
    return ListView.separated(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final mess = listNew.toList()[index];
          return Container(
            child: Column(
              children: [
                Text(
                  '${widget.name} đã gửi',
                  style: TextStyle(color: Colors.red),
                ),
                Text(mess),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(color: Colors.black26),
        itemCount: listNew.length);
  }

  void sendMessenger(String messenger) {
    setState(() {
      // listMessenger.insert(0, messenger);
      listMessenger.add(messenger);
      listNew = listMessenger.reversed;
    });
  }
}
