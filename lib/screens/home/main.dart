import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_event.dart';
import 'package:picospaintballzone/bloc/auth/auth_state.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_bloc.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_event.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_state.dart';
import 'package:picospaintballzone/bloc/user/user_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_event.dart';
import 'package:picospaintballzone/bloc/user/user_state.dart';
import 'package:picospaintballzone/screens/login/main.dart';
import 'package:picospaintballzone/shared/constants/assets_constants.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(GetCurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const AutoSizeText(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => BlocProvider.of<AuthBloc>(context).add(LogoutEvent()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, authState){
            if(authState is DoneLogoutState){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState){
              if(userState is LoadingUserState){
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
              } else if(userState is ErrorUserState){
                return Center(
                  child: AutoSizeText(
                    userState.message,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if(userState is DoneGetUserState){
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
                                              child: userState.user.qtdPoints! > index
                                                  ? Image.asset(AssetsConstants.logoPng)
                                                  : const Center(),
                                            ),
                                          );
                                        }),
                                      ),
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
              return const Center();
            },
          ),
        ),
      ),
    );
  }
}
