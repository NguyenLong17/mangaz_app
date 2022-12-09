import 'package:flutter/material.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/common/widgets/mybutton.dart';
import 'package:manga_app/common/widgets/mytextfield.dart';
import 'package:manga_app/page/page_demo/messenger_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: 'Chat page',
      ),
      body: Column(
        children: [
          MyTextField(
            labelText: 'Name',
            controller: nameController,
          ),
          MyButton(
            textButton: 'Chat',
            backgroundColor: Colors.green,
            onTap: () {
              navigatorPush(
                  context,
                  MessengerPage(
                    name: nameController.text,
                  ));
            },
          ),
        ],
      ),
    );
  }
}
