import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:picospaintballzone/shared/widgets/alert_dialog_widget.dart';
import 'package:picospaintballzone/shared/widgets/primary_button_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/colors.dart';

class Utils{
  static const List<String> blackList = [
    "00000000000000",
    "11111111111111",
    "22222222222222",
    "33333333333333",
    "44444444444444",
    "55555555555555",
    "66666666666666",
    "77777777777777",
    "88888888888888",
    "99999999999999"
  ];
  static const stripRegex = r'[^\d]';

  static double getMaxHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double getMaxWidth(BuildContext context) => MediaQuery.of(context).size.width;

  static void navigateToFirstScreen({required BuildContext context}) => Navigator.popUntil(context, (route) => route.isFirst);

  static void showDialogUtil({
    required BuildContext context,
    required String title,
    required String txtConfirmButton,
    required Function() onPressedConfirm,
    required bool isDismissible,
    String? txtCancelButton,
    Function()? onPressedCancel,
    Widget? content,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AlertDialogWidget(
        title: title,
        txtConfirmButton: txtConfirmButton,
        onPressedConfirm: onPressedConfirm,
        txtCancelButton: txtCancelButton,
        onPressedCancel: onPressedCancel,
        content: content,
      ),
    );
  }

  static showMessageDialog({required BuildContext context, required String txt, required bool isSuccess}) {
    Flushbar(
      message: txt,
      messageSize: 16,
      icon: Icon(
        isSuccess ? Icons.check_circle_outline_rounded : Icons.warning,
        color: Colors.white,
        size: 24.0,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(10),
      backgroundColor:
      isSuccess ? AppColors.primaryGreen : AppColors.primaryRed,
    ).show(context);
  }

  static bool isValidDate(String date) {
    if (date.length == 10) {
      try {
        DateFormat("dd/MM/yyyy").parseStrict(date);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool?> confirmAction({required BuildContext context, required String actionName}) async {
    bool confirm = false;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        scrollable: true,
        content: SizedBox(
          width: Utils.getMaxWidth(context),
          height: Utils.getMaxHeight(context) * 0.3,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  "Tem certeza que deseja $actionName?",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButtonTextIcon(
                      text: "Não",
                      icon: Icons.cancel_outlined,
                      color: AppColors.primaryRed,
                      textColor: Colors.white,
                      width: 150,
                      isEnabled: true,
                      press: () {
                        Navigator.pop(context);
                        confirm = false;
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    PrimaryButtonTextIcon(
                      text: "Sim",
                      width: 150,
                      icon: Icons.done,
                      color: AppColors.primaryGreen,
                      textColor: Colors.white,
                      isEnabled: true,
                      press: () {
                        Navigator.pop(context);
                        confirm = true;
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    return confirm;
  }

  static String? validateCPFCNPJ(String value) {
    final onlyDigits = value.replaceAll(RegExp(r'\D'), '');

    if (onlyDigits.length == 11) {
      final isCpfValid = validateCPF(onlyDigits);
      return !isCpfValid ? 'CPF inválido!' : null;
    } else if (onlyDigits.length == 14) {
      final isCnpjValid = validateCNPJ(onlyDigits);
      return !isCnpjValid ? 'CNPJ inválido!' : null;
    }

    return null;
  }

  static bool validateCPF(String cpf) {
    final onlyDigits = cpf.replaceAll(RegExp(r'\D'), '');

    if (onlyDigits.length != 11) {
      return false;
    }

    if (RegExp(r'^(\d)\1{10}$').hasMatch(onlyDigits)) {
      return false;
    }

    final digits = onlyDigits.split('').map(int.parse).toList();

    int calculateDigit(List<int> slice) {
      var sum = 0;

      for (var i = 0; i < slice.length; i++) {
        sum += slice[i] * (slice.length + 1 - i);
      }

      var remainder = sum % 11;
      return remainder < 2 ? 0 : 11 - remainder;
    }

    final verificationDigit1 = calculateDigit(digits.sublist(0, 9));
    final verificationDigit2 = calculateDigit(digits.sublist(0, 9) + [verificationDigit1]);

    return digits[9] == verificationDigit1 && digits[10] == verificationDigit2;
  }


  static bool validateCNPJ(String? cnpj, [stripBeforeValidation = true]) {
    if (stripBeforeValidation) {
      cnpj = strip(cnpj);
    }

    // cnpj must be defined
    if (cnpj == null || cnpj.isEmpty) {
      return false;
    }

    // cnpj must have 14 chars
    if (cnpj.length != 14) {
      return false;
    }

    // cnpj can't be blacklisted
    if (blackList.contains(cnpj)) {
      return false;
    }

    String numbers = cnpj.substring(0, 12);
    numbers += _verifierDigit(numbers).toString();
    numbers += _verifierDigit(numbers).toString();

    return numbers.substring(numbers.length - 2) ==
        cnpj.substring(cnpj.length - 2);
  }

  static String strip(String? cnpj) {
    RegExp regex = RegExp(stripRegex);
    cnpj = cnpj ?? "";

    return cnpj.replaceAll(regex, "");
  }

  static int _verifierDigit(String cnpj) {
    int index = 2;

    List<int> reverse =
    cnpj.split("").map((s) => int.parse(s)).toList().reversed.toList();

    int sum = 0;

    for (var number in reverse) {
      sum += number * index;
      index = (index == 9 ? 2 : index + 1);
    }

    int mod = sum % 11;

    return (mod < 2 ? 0 : 11 - mod);
  }

  static String? showDateTimeString({required String date}){
    try {
      final dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return null;
    }
  }

  static DateTime? convertStringToDateTimeWithHours(String date) {
    try {
      return DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);
    } catch (e) {
      return null;
    }
  }

  static DateTime? convertStringToDateTime(String date, {bool? isDateBr}) {
    try {
      if (isDateBr ?? false) {
        return DateFormat("dd-MM-yyyy").parse(date.replaceAll('/', '-'));
      } else {
        return DateFormat("yyyy-MM-dd").parse(date);
      }
    } catch (e) {
      return null;
    }
  }

  static String convertDateToString(DateTime? date) {
    if (date == null) return '';
    try {
      final dateTime = DateFormat("yyyy-MM-dd").parse(date.toString());
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    } catch (e) {
      return '';
    }
  }

  static String convertDateHourToString(DateTime date) {
    try {
      final dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date.toString());
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute}";
    } catch (e) {
      return '';
    }
  }

  static String? formatStringToDateBr(String date, {bool? isDateBr}) {
    DateTime? dateTime;
    try {
      if (isDateBr ?? false) {
        dateTime = DateFormat("dd-MM-yyyy").parse(date.replaceAll('/', '-'));
      } else {
        dateTime = DateFormat("yyyy-MM-dd").parse(date);
      }
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    } catch (e) {
      return null;
    }
  }

  static String? formatStringToDate(String date, {bool? isDateBr}) {
    DateTime? dateTime;
    try {
      if (isDateBr ?? false) {
        dateTime = DateFormat("dd-MM-yyyy").parse(date.replaceAll('/', '-'));
      } else {
        dateTime = DateFormat("yyyy-MM-dd").parse(date);
      }
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return null;
    }
  }

}