import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatefulWidget {
  const AlertDialogWidget({Key? key, required this.title, required this.txtConfirmButton, this.txtCancelButton, required this.onPressedConfirm, this.onPressedCancel, this.content}) : super(key: key);
  final String title;
  final String txtConfirmButton;
  final String? txtCancelButton;
  final Function() onPressedConfirm;
  final Function()? onPressedCancel;
  final Widget? content;

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
        ),
      ),
      content: widget.content ?? const SizedBox(height: 0,),
      actions: [
        if(widget.onPressedCancel != null && widget.txtCancelButton != null)
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.primaryRedDark;
                }
                return AppColors.primaryRed;
              }),
            ),
            onPressed: widget.onPressedCancel,
            child: Text(widget.txtCancelButton!),
          ),
        ElevatedButton(
          onPressed: widget.onPressedConfirm,
          child: Text(widget.txtConfirmButton),
        ),
      ],
    );
  }
}
