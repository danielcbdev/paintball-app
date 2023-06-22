import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:picospaintballzone/bloc/matches/matches_bloc.dart';
import 'package:picospaintballzone/bloc/matches/matches_event.dart';
import 'package:picospaintballzone/models/match/match.model.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';
import 'package:picospaintballzone/shared/widgets/primary_button.dart';
import 'package:picospaintballzone/shared/widgets/primary_textfield.dart';

class MatchWidget extends StatefulWidget {
  const MatchWidget({Key? key, this.match}) : super(key: key);
  final MatchModel? match;

  @override
  State<MatchWidget> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {

  final _controllerIndividualValue = TextEditingController();

  void _initData(){
    print('entrou no initdata');
  }

  @override
  void initState() {
    super.initState();
    if(widget.match != null){
      _initData();
    } else{
      print('entrou no else');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        PrimaryTextField(
          labelText: 'Valor individual da entrada',
          controller: _controllerIndividualValue,
          backgroundColor: Colors.white,
          enabled: true,
          onChanged: (value){},
          type: PrimaryTextfieldType.decimal,
        ),
        const SizedBox(height: 20,),
        PrimaryButton(
          text: 'Adicionar participante',
          isEnabled: true,
          color: AppColors.primaryColor,
          textColor: Colors.white,
          press: () => _showDialogAddPlayer(context: context),
        ),
      ],
    );
  }

  _showDialogAddPlayer({required BuildContext context}){
    final controllerName = TextEditingController();

    showMaterialModalBottomSheet(
      context: context,
      isDismissible: true,
      useRootNavigator: true,
      elevation: 4,
      expand: false,
      closeProgressThreshold: 0.3,
      backgroundColor: AppColors.primaryGreyLight,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SizedBox(
          width: Utils.getMaxWidth(context),
          height: Utils.getMaxHeight(context) * 0.4,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryTextField(
                  labelText: 'Nome',
                  controller: controllerName,
                  backgroundColor: Colors.white,
                  enabled: true,
                  onChanged: (value){},
                  type: PrimaryTextfieldType.text,
                ),
                const SizedBox(height: 20,),
                PrimaryButton(
                  text: 'Adicionar',
                  isEnabled: true,
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  press: () {
                    if(controllerName.text.isEmpty){
                      Utils.showMessageDialog(context: context, txt: 'Insira o nome do usuário', isSuccess: false,);
                    } else{
                      Navigator.pop(context);
                      BlocProvider.of<MatchesBloc>(context).add(AddPlayerInMatchEvent(name: _controllerIndividualValue.text));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
