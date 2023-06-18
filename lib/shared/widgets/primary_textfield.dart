import 'package:brasil_fields/brasil_fields.dart';
import 'package:picospaintballzone/shared/constants/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../theme/colors.dart';
import '../utils/utils.dart';

class PrimaryTextField extends HookWidget {
  final String? labelText;

  final bool enabled;
  const PrimaryTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.enabled,
    required this.onChanged,
    required this.type,
    this.validator,
    this.hasPrefix,
    this.prefix,
    this.currentSearchTerm,
    this.autoFocus,
    this.onFieldSubmitted,
    this.sufixIcon,
    this.initialValue,
    this.backgroundColor,
    this.isRequired = false,
  }) : super(key: key);
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final PrimaryTextfieldType type;
  final bool? hasPrefix;
  final Widget? prefix;
  final ValueNotifier<String>? currentSearchTerm;
  final bool? autoFocus;
  final void Function(String)? onFieldSubmitted;
  final Widget? sufixIcon;
  final String? initialValue;
  final Color? backgroundColor;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);
    final numberKeyboardNode = useFocusNode();

    return TextFormField(
      enabled: enabled,
      maxLines: type == PrimaryTextfieldType.multiline ? null : 1,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator ??
        (type == PrimaryTextfieldType.cpfOrCnpj ? (value) => Utils.validateCPFCNPJ(value!) :
            type == PrimaryTextfieldType.dateComplete
          ? (value){
            if (value!.length < 10) {
                return null;
              } else if (!Utils.isValidDate(value)) {
              return 'Data inválida!';
            }
            return null;
          }
          : type == PrimaryTextfieldType.email
            ? (value){
                if(value == null || value.isEmpty){
                  return 'Insira o e-mail';
                }
                final emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
                if(!emailRegex.hasMatch(value)){
                  return 'E-mail inválido';
                }
                return null;
              }
              : isRequired
              ? (value){
                if (value == null || value.isEmpty) {
                    return 'Por favor, insira a informação!';
                  }
                return null;
              }
              : (value){
                  return;
                }
          ),
      textCapitalization: type == PrimaryTextfieldType.name ? TextCapitalization.words : TextCapitalization.none,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        fontSize: 24,
        height: 2,
        color: !enabled
            ? Colors.black.withOpacity(0.7)
            : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      controller: controller,
      focusNode: numberKeyboardNode,
      autofocus: autoFocus ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: type == PrimaryTextfieldType.password && obscureText.value,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: "$labelText${isRequired ? ' *' : ''}",
        labelStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.7),
        ),
        floatingLabelBehavior: type == PrimaryTextfieldType.search ||
            type == PrimaryTextfieldType.chat
            ? FloatingLabelBehavior.never
            : FloatingLabelBehavior.auto,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 18,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Nunito',
          height: 0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        filled: true,
        fillColor: backgroundColor ?? (type == PrimaryTextfieldType.address ||
            type == PrimaryTextfieldType.addressNumber ||
            type == PrimaryTextfieldType.addressCep
            ? Colors.transparent
            : AppColors.primaryGreyLight
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: type == PrimaryTextfieldType.address ||
              type == PrimaryTextfieldType.addressNumber ||
              type == PrimaryTextfieldType.addressCep
              ? 0
              : 20,
          vertical: 10,
        ),
        focusedBorder: type == PrimaryTextfieldType.address ||
            type == PrimaryTextfieldType.addressNumber ||
            type == PrimaryTextfieldType.addressCep
            ? const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        )
            : OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(13.30),
        ),
        enabledBorder: type == PrimaryTextfieldType.address ||
            type == PrimaryTextfieldType.addressNumber ||
            type == PrimaryTextfieldType.addressCep
            ? UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.5),
          ),
        )
            : OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(13.30),
        ),
        border: type == PrimaryTextfieldType.address ||
            type == PrimaryTextfieldType.addressNumber ||
            type == PrimaryTextfieldType.addressCep
            ? const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        )
            : OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(13.30),
        ),
        errorBorder: type == PrimaryTextfieldType.address ||
            type == PrimaryTextfieldType.addressNumber ||
            type == PrimaryTextfieldType.addressCep
            ? const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        )
            : OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(13.30),
        ),
        suffixIcon: sufixIcon ??
            suffixWidget(
              type,
              obscureText,
              currentSearchTerm,
              controller,
            ),
        prefixIcon: hasPrefix ?? false
            ? Padding(
          padding: const EdgeInsets.all(22.0),
          child: prefix,
        )
            : null,
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: getTextInputFormatters(type),
      keyboardType: getTextInputType(type),
    );
  }
}

enum PrimaryTextfieldType {
  name,
  text,
  search,
  email,
  password,
  money,
  number,
  decimal,
  phone,
  date,
  dateComplete,
  time,
  multiline,
  cep,
  latLng,
  cpf,
  address,
  addressNumber,
  addressCep,
  chat,
  card,
  cpfOrCnpj,
  cardValidity,
  cvv,
  subscriptionImobile,
}

TextInputAction getTextInputAction(PrimaryTextfieldType type,) {
  switch (type) {
    case PrimaryTextfieldType.text:
      return TextInputAction.done;

    case PrimaryTextfieldType.phone:
      return TextInputAction.done;

    case PrimaryTextfieldType.chat:
      return TextInputAction.done;

    default:
      return TextInputAction.done;
  }
}

TextInputType getTextInputType(
    PrimaryTextfieldType type,
    ) {
  switch (type) {
    case PrimaryTextfieldType.name:
      return TextInputType.name;

    case PrimaryTextfieldType.text:
      return TextInputType.text;

    case PrimaryTextfieldType.email:
      return TextInputType.emailAddress;

    case PrimaryTextfieldType.password:
      return TextInputType.text;

    case PrimaryTextfieldType.chat:
      return TextInputType.text;

    case PrimaryTextfieldType.money:
      return TextInputType.number;

    case PrimaryTextfieldType.cep:
      return TextInputType.number;

    case PrimaryTextfieldType.latLng:
      return TextInputType.number;

    case PrimaryTextfieldType.number:
      return TextInputType.number;

    case PrimaryTextfieldType.addressNumber:
      return TextInputType.number;

    case PrimaryTextfieldType.addressCep:
      return TextInputType.number;

    case PrimaryTextfieldType.phone:
      return TextInputType.phone;

    case PrimaryTextfieldType.cpf:
      return TextInputType.phone;

    case PrimaryTextfieldType.date:
      return TextInputType.datetime;

    case PrimaryTextfieldType.decimal:
      return TextInputType.number;

    case PrimaryTextfieldType.dateComplete:
      return TextInputType.datetime;

    case PrimaryTextfieldType.card:
      return TextInputType.number;

    case PrimaryTextfieldType.cpfOrCnpj:
      return TextInputType.number;

    case PrimaryTextfieldType.subscriptionImobile:
      return TextInputType.number;

    case PrimaryTextfieldType.cardValidity:
      return TextInputType.number;

    case PrimaryTextfieldType.cvv:
      return TextInputType.number;

    default:
      return TextInputType.text;
  }
}

List<TextInputFormatter> getTextInputFormatters(
    PrimaryTextfieldType type,
    ) {
  switch (type) {
    case PrimaryTextfieldType.phone:
      return [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ];

    case PrimaryTextfieldType.addressCep:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(ponto: false),
      ];

    case PrimaryTextfieldType.cpf:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ];

    case PrimaryTextfieldType.date:
      return [
        MaskTextInputFormatter(
          mask: '##/##',
          filter: {"#": RegExp(r'[0-9]')},
        ),
      ];

    case PrimaryTextfieldType.dateComplete:
      return [
        FilteringTextInputFormatter.digitsOnly,
        DataInputFormatter()
      ];

    case PrimaryTextfieldType.card:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CartaoBancarioInputFormatter()
      ];

    case PrimaryTextfieldType.cpfOrCnpj:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CpfOuCnpjFormatter()
      ];

    case PrimaryTextfieldType.subscriptionImobile:
      return [
        MaskTextInputFormatter(
          mask: '##.##.###.####-##',
          filter: {"#": RegExp(r'[0-9]')},
        ),
      ];

    case PrimaryTextfieldType.cardValidity:
      return [
        FilteringTextInputFormatter.digitsOnly,
        ValidadeCartaoInputFormatter()
      ];

    case PrimaryTextfieldType.cvv:
      return [
        MaskTextInputFormatter(
          mask: '###',
          filter: {"#": RegExp(r'[0-9]')},
        ),
      ];

    case PrimaryTextfieldType.money:
      return [
        FilteringTextInputFormatter.digitsOnly,
        RealInputFormatter(),
      ];

    case PrimaryTextfieldType.decimal:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(),
      ];

    case PrimaryTextfieldType.cep:
      return [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(),
      ];

    case PrimaryTextfieldType.latLng:
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9-.]')),
      ];

    case PrimaryTextfieldType.number:
      return [
        FilteringTextInputFormatter.digitsOnly,
      ];

    default:
      return [];
  }
}

Widget? suffixWidget(
    PrimaryTextfieldType type,
    ValueNotifier<bool> obscureText,
    ValueNotifier<String>? currentSearchTerm,
    TextEditingController? controller,
    ) {
  switch (type) {
    case PrimaryTextfieldType.password:
      return GestureDetector(
        onTap: () {
          obscureText.value = !obscureText.value;
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            obscureText.value
                ? AssetsConstants.eyeSlashedIcon
                : AssetsConstants.eyeIcon,
            color: Colors.black,
            height: 20,
          ),
        ),
      );

    case PrimaryTextfieldType.search:
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: currentSearchTerm!.value.isEmpty
            ? Lottie.asset(
          AssetsConstants.searchIcon,
          height: 34,
        )
            : InkWell(
          onTap: () {
            controller?.clear();
            currentSearchTerm.value = '';
          },
          child: SvgPicture.asset(
            AssetsConstants.closeIcon,
            height: 20,
          ),
        ),
      );
    case PrimaryTextfieldType.chat:
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {},
          child: SvgPicture.asset(
            AssetsConstants.sendIcon,
            height: 20,
          ),
        ),
      );
    default:
      return null;
  }
}

//Number keyboard focus node method
bool isNumberKeyboard(PrimaryTextfieldType type) {
  switch (type) {
    case PrimaryTextfieldType.number:
      return true;

    case PrimaryTextfieldType.phone:
      return true;

    case PrimaryTextfieldType.addressNumber:
      return true;

    case PrimaryTextfieldType.addressCep:
      return true;

    case PrimaryTextfieldType.cpf:
      return true;

    default:
      return false;
  }
}
