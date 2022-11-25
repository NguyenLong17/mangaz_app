import 'package:flutter/material.dart';

class TabBarStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;
  final Function? next;
  final Function? previous;

  const TabBarStack(
      {Key? key,
      required this.index,
      required this.children,
      this.duration = const Duration(
        milliseconds: 300,
      ),
      this.next,
      this.previous})
      : super(key: key);

  @override
  State<TabBarStack> createState() => _TabBarStackState();
}

class _TabBarStackState extends State<TabBarStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double initial = 0;
  double distance = 0;

  @override
  void didUpdateWidget(TabBarStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (DragStartDetails details) {
        initial = details.globalPosition.dx;
      },
      onPanUpdate: (DragUpdateDetails details) {
        distance = details.globalPosition.dx - initial;
      },
      onPanEnd: (DragEndDetails details) {
        initial = 0.0;
        if (distance > 30) {
          if (widget.previous != null) {
            widget.previous!();
          }
        } else if (distance < -30) {
          if (widget.next != null) {
            widget.next!();
          }
        }
      },
      child: FadeTransition(
        opacity: _controller,
        child: IndexedStack(
          index: widget.index,
          children: widget.children,
        ),
      ),
    );
  }
}
