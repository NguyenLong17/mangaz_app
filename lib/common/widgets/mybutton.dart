import 'package:flutter/material.dart';
import 'package:manga_app/common/bloc_common/button_bloc.dart';

class MyButton extends StatefulWidget {
  final String textButton;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const MyButton({
    super.key,
    required this.textButton,
    this.textColor = Colors.black,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  late MyButtonBloc bloc;

  @override
  void initState() {
    bloc = MyButtonBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: bloc.myButtonStream,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              bloc.onTapButton(() {
                widget.onTap();
              });
            },
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    bloc.isSelect ? Colors.grey[300] : widget.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.textButton,
                style: TextStyle(
                  color: widget.textColor,
                ),
              ),
            ),
          );
        });
  }
}
