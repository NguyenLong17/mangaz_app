import 'package:flutter/material.dart';

void showConfirmDialog({
  required BuildContext context,
  String? title,
  required String message,
  VoidCallback? onConfirm,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.grey.withOpacity(0.2),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (_, __, ___) {
      return Container(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: DialogConfirm(
            title: title,
            message: message,
            onConfirm: () {
              onConfirm!();
            },
          ),
        ),
      );
    },
  );
}

class DialogConfirm extends StatefulWidget {
  final String? title;
  final String message;
  final VoidCallback onConfirm;

  const DialogConfirm({
    super.key,
    this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  State<DialogConfirm> createState() => _DialogConfirmState();
}

class _DialogConfirmState extends State<DialogConfirm> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 64, vertical: 64),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            widget.message,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirm();
                  },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}


