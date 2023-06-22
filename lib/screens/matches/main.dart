import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:picospaintballzone/bloc/matches/matches_bloc.dart';
import 'package:picospaintballzone/bloc/matches/matches_event.dart';
import 'package:picospaintballzone/bloc/matches/matches_state.dart';
import 'package:picospaintballzone/models/match/match.model.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';
import 'package:picospaintballzone/shared/widgets/primary_button.dart';
import 'package:picospaintballzone/shared/widgets/primary_textfield.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {

  final _controllerIndividualValue = TextEditingController();
  final _listChargeOptions = [
    10.0,
    20.0,
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MatchesBloc>(context).add(GetCurrentMatchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const AutoSizeText(
          'Partida',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: BlocConsumer<MatchesBloc, MatchesState>(
              listener: (context, state){
                if(state is DoneUpdateCurrentMatchState){
                  Utils.showMessageDialog(context: context, txt: 'Sucesso!', isSuccess: true,);
                  BlocProvider.of<MatchesBloc>(context).add(GetCurrentMatchEvent());
                }
              },
              builder: (context, state){
                if(state is ErrorMatchesState){
                  return Center(
                    child: AutoSizeText(
                      state.message,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if(state is DoneGetCurrentMatchState){
                  if(state.match?.individualPrice != null){
                    _controllerIndividualValue.text = '${state.match?.individualPrice}';
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryTextField(
                              labelText: 'Valor individual da entrada',
                              controller: _controllerIndividualValue,
                              backgroundColor: Colors.white,
                              enabled: true,
                              onChanged: (value){},
                              type: PrimaryTextfieldType.decimal,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save, color: AppColors.primaryColor, size: 30,),
                            onPressed: (){
                              if(_controllerIndividualValue.text.isEmpty){
                                Utils.showMessageDialog(context: context, txt: 'Insira o valor individual da entrada!', isSuccess: false,);
                              } else{
                                BlocProvider.of<MatchesBloc>(context).add(
                                  AddIndividualValueEvent(individualValue: double.parse(_controllerIndividualValue.text.replaceAll(',', '.'))),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (state.match?.players ?? []).map((e) {
                          return Container(
                            width: Utils.getMaxWidth(context),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5,),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        '${e.name}',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle, color: AppColors.primaryColor,),
                                      onPressed: () => _showDialogAddCharge(indexUser: e.index!),
                                    ),
                                  ],
                                ),
                                const Divider(height: 30, thickness: 2),
                                const AutoSizeText(
                                  'Recargas',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AutoSizeText(
                                      'R\$10,00: ${(e.recharges ?? []).where((element) => element == 10).length}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    AutoSizeText(
                                      'R\$20,00: ${(e.recharges ?? []).where((element) => element == 20).length}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 30, thickness: 2),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AutoSizeText(
                                      'Recargas: R\$${_calculateTotalRecharges(recharges: e.recharges ?? [])}',
                                      style: const TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AutoSizeText(
                                      'Total: R\$${_calculateTotal(recharges: (e.recharges ?? []))}',
                                      style: const TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 50,),
                      PrimaryButton(
                        text: 'Adicionar participante',
                        isEnabled: true,
                        color: AppColors.primaryColor,
                        textColor: Colors.white,
                        press: () => _showDialogAddPlayer(),
                      ),
                      const SizedBox(height: 20,),
                      AutoSizeText(
                        'Total de jogadores: ${(state.match?.players ?? []).length}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      AutoSizeText(
                        'Total arrecadado na partida: R\$${_calculateTotalCollected(players: state.match?.players ?? [], individualValue: state.match?.individualPrice ?? 0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryGreen
                        ),
                      ),
                      const SizedBox(height: 30,),
                    ],
                  );
                }
                return const Center();
              },
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        PrimaryButton(
          text: 'Zerar partida',
          isEnabled: true,
          color: AppColors.primaryRedDark,
          textColor: Colors.white,
          press: () async {
            await Utils.confirmAction(context: context, actionName: 'zerar a partida').then((value) {
              if(value ?? false){
                _controllerIndividualValue.text = '';
                BlocProvider.of<MatchesBloc>(context).add(ClearMathEventEvent());
              }
            });
          },
        ),
      ],
    );
  }

  double _calculateTotalCollected({required List<Player> players, required double individualValue}){
    double total = 0;
    for (var player in players) {
      player.recharges?.forEach((charge) {
        total += charge;
      });
    }
    return total + (individualValue * players.length);
  }
  double _calculateTotal({required List<double> recharges}){
    double total = 0;
    double entryValue = _controllerIndividualValue.text.isEmpty ? 0 : double.parse(_controllerIndividualValue.text.replaceAll(',', '.'));
    for (var element in recharges) {
      total += element;
    }
    return total + entryValue;
  }
  double _calculateTotalRecharges({required List<double> recharges}){
    double total = 0;
    for (var element in recharges) {
      total += element;
    }
    return total;
  }
  _showDialogAddPlayer(){
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
                      BlocProvider.of<MatchesBloc>(context).add(AddPlayerInMatchEvent(name: controllerName.text));
                      Navigator.pop(context);
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
  _showDialogAddCharge({required int indexUser}){
    final chargeSelected = ValueNotifier<double?>(null);

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
                const AutoSizeText(
                  'Selecione o valor da recarga',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20,),
                ValueListenableBuilder<double?>(
                  valueListenable: chargeSelected,
                  builder: (context, chargeValue, _){
                    return Column(
                      children: [
                        DropdownButton<double>(
                          value: chargeValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: AppColors.primaryColor,
                          ),
                          onChanged: (double? value) {
                            chargeSelected.value = value;
                          },
                          items: _listChargeOptions.map<DropdownMenuItem<double>>((double value) {
                            return DropdownMenuItem<double>(
                              value: value,
                              child: Text('R\$$value', style: const TextStyle(fontSize: 18),),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20,),
                        PrimaryButton(
                          text: 'Adicionar recarga',
                          isEnabled: chargeValue != null,
                          color: AppColors.primaryColor,
                          textColor: Colors.white,
                          press: () {
                            BlocProvider.of<MatchesBloc>(context).add(
                              AddChargeEvent(
                                indexUser: indexUser,
                                chargeValue: chargeSelected.value ?? 0,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
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
