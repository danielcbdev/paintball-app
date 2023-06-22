import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_bloc.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_event.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_state.dart';
import 'package:picospaintballzone/bloc/user/user_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_event.dart';
import 'package:picospaintballzone/bloc/user/user_state.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';
import 'package:picospaintballzone/shared/widgets/primary_button.dart';
import 'package:picospaintballzone/shared/widgets/primary_textfield.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key, required this.snapshotClient}) : super(key: key);
  final DocumentSnapshot snapshotClient;

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const AutoSizeText(
          'Cliente',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocProvider<FidelityCardBloc>(
            create: (context) => FidelityCardBloc()..add(GetFidelityCardConfigEvent()),
            child: BlocBuilder<FidelityCardBloc, FidelityCardState>(
              builder: (context, fidelityCardState){
                if(fidelityCardState is LoadingFidelityCardState){
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                } else if(fidelityCardState is ErrorFidelityCardState){
                  return Center(
                    child: AutoSizeText(
                      fidelityCardState.message,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if(fidelityCardState is DoneGetFidelityCardConfigState){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      _itemEditText(
                        title: 'Nome',
                        labelText: widget.snapshotClient['name'],
                      ),
                      const SizedBox(height: 10,),
                      _itemEditText(
                        title: 'E-mail',
                        labelText: widget.snapshotClient['email'],
                      ),
                      const SizedBox(height: 10,),
                      _itemEditText(
                        title: 'CPF',
                        labelText: widget.snapshotClient['cpf'],
                      ),
                      const SizedBox(height: 10,),
                      if(_isFullFidelityCard(maxPoints: fidelityCardState.fidelityCardConfig.maxPoints!))
                        const AutoSizeText(
                          'Cliente com cartão de fidelidade cheio!!',
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      else
                        _itemEditText(
                          title: 'Quantidade de pontos',
                          labelText: '${widget.snapshotClient['qtd_points']}',
                        ),
                      const SizedBox(height: 30,),
                      BlocProvider<UserBloc>(
                        create: (context) => UserBloc(),
                        child: BlocConsumer<UserBloc, UserState>(
                            listener: (context, state){
                              if(state is DoneAddPointToUserState){
                                Navigator.pop(context);
                                Utils.showMessageDialog(context: context, txt: 'Ponto adicionado com sucesso!', isSuccess: true,);
                              }
                            },
                            builder: (context, state){
                              return PrimaryButton(
                                text: _isFullFidelityCard(maxPoints: fidelityCardState.fidelityCardConfig.maxPoints!) ? 'Zerar cartão' : 'Adicionar ponto',
                                isEnabled: state is! LoadingUserState,
                                isLoading: state is LoadingUserState,
                                color: AppColors.primaryColor,
                                textColor: Colors.white,
                                press: (){
                                  int? newQtdPoints;
                                  if(_isFullFidelityCard(maxPoints: fidelityCardState.fidelityCardConfig.maxPoints!)){
                                    newQtdPoints = 0;
                                  } else{
                                    newQtdPoints = widget.snapshotClient['qtd_points'] + 1;
                                  }
                                  BlocProvider.of<UserBloc>(context).add(
                                    AddPointToUserEvent(
                                      uidUser: widget.snapshotClient['uid'],
                                      newQtdPoints: newQtdPoints!,
                                    ),
                                  );
                                },
                              );
                            }
                        ),
                      ),
                    ],
                  );
                }
                return const Center();
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _isFullFidelityCard({required int maxPoints}) => widget.snapshotClient['qtd_points'] >= maxPoints;
  Widget _itemEditText({required String title, required String labelText,}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 2),
          child: AutoSizeText(
            title,
            style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: PrimaryTextField(
            labelText: labelText,
            backgroundColor: Colors.white,
            enabled: false,
            onChanged: (value) {},
            validator: (value) {
              return;
            },
            controller: null,
            type: PrimaryTextfieldType.text,
          ),
        ),
      ],
    );
  }
}
