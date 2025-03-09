import 'package:flutter/material.dart';

void showDeleteConfirmationDialog({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required Future<void> Function() onDelete,
  String acceptButtontitle = "Delete",
}) {
  showDialog(
    context: context,
    builder: (context) => _DeleteConfirmationDialog(
      title: title,
      content: content,
      onDelete: onDelete,
      acceptButtontitle: acceptButtontitle,
    ),
  );
}

class _DeleteConfirmationDialog extends StatefulWidget {
  final Widget title;
  final Widget content;
  final Future<void> Function() onDelete;
  final String acceptButtontitle;

  const _DeleteConfirmationDialog({
    required this.title,
    required this.content,
    required this.onDelete,
    required this.acceptButtontitle,
  });

  @override
  __DeleteConfirmationDialogState createState() =>
      __DeleteConfirmationDialogState();
}

class __DeleteConfirmationDialogState extends State<_DeleteConfirmationDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: widget.content,
      actions: [
        TextButton(
          onPressed: () {
            if (!_isDeleting) {
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Cancel',
          ),
        ),
        TextButton(
          onPressed: () async {
            if (!_isDeleting) {
              setState(() {
                _isDeleting = true;
              });

              await widget.onDelete();

              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: _isDeleting
              ? const CircularProgressIndicator()
              : Text(
                  widget.acceptButtontitle,
                ),
        ),
      ],
    );
  }
}
