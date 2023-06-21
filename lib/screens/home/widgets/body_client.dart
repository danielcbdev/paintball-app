import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_bloc.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_event.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_state.dart';
import 'package:picospaintballzone/bloc/user/user_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_event.dart';
import 'package:picospaintballzone/models/user/user.model.dart';
import 'package:picospaintballzone/shared/constants/assets_constants.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';

class BodyClientWidget extends StatefulWidget {
  const BodyClientWidget({Key? key, required this.user,}) : super(key: key);
  final UserModel? user;

  @override
  State<BodyClientWidget> createState() => _BodyClientWidgetState();
}

class _BodyClientWidgetState extends State<BodyClientWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FidelityCardBloc>(
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
            return RefreshIndicator(
              onRefresh: () async => BlocProvider.of<UserBloc>(context).add(GetCurrentUserEvent()),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    AutoSizeText(
                      'Bem vindo(a) ${widget.user?.name}',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: Utils.getMaxWidth(context),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const AutoSizeText(
                            'Cartão de Fidelidade Virtual',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: (fidelityCardState.fidelityCardConfig.maxPoints ?? 0) ~/ 2,
                            children: List.generate(fidelityCardState.fidelityCardConfig.maxPoints ?? 0, (index) {
                              return Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: widget.user!.qtdPoints! > index
                                      ? Image.asset(AssetsConstants.logoPng)
                                      : const Center(),
                                ),
                              );
                            }),
                          ),
                          if(widget.user!.qtdPoints! >= fidelityCardState.fidelityCardConfig.maxPoints!)
                            const AutoSizeText(
                              'Parabéns!!!!\nVocê completou o cartão :)\nEntre em contato conosco e combine quando irá resgatar seu prêmio!',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          else
                            AutoSizeText(
                              'A cada ${(fidelityCardState.fidelityCardConfig.maxPoints ?? 0)} jogos realizados, você ganha ${fidelityCardState.fidelityCardConfig.award}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center();
        },
      ),
    );
  }
}
