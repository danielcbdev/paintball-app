import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_event.dart';
import 'package:picospaintballzone/bloc/auth/auth_state.dart';
import 'package:picospaintballzone/bloc/user/user_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_event.dart';
import 'package:picospaintballzone/bloc/user/user_state.dart';
import 'package:picospaintballzone/screens/home/widgets/body_admin.dart';
import 'package:picospaintballzone/screens/home/widgets/body_client.dart';
import 'package:picospaintballzone/screens/login/main.dart';
import 'package:picospaintballzone/screens/matches/main.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isUserAdmin = false;

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
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, userState){
              if(userState is DoneGetUserState){
                setState(() {
                  _isUserAdmin = userState.user.isAdm ?? false;
                });
              }
            },
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
                if(userState.user.isAdm ?? false){
                  return BodyAdminWidget(user: userState.user);
                } else{
                  return BodyClientWidget(user: userState.user);
                }
              }
              return const Center();
            },
          ),
        ),
      ),
      persistentFooterButtons: [
        if(_isUserAdmin)
          PrimaryButton(
            text: 'Nova partida (sem sincronização com a núvem)',
            isEnabled: true,
            color: AppColors.primaryGreen,
            textColor: Colors.white,
            press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchesScreen())),
          )
        else
          PrimaryButton(
            text: 'Entrar em contato pelo WhatsApp',
            isEnabled: true,
            color: AppColors.primaryGreen,
            textColor: Colors.white,
            press: () => _launchUrl(),
          )
      ],
    );
  }

  Future<void> _launchUrl() async {
    const url = 'https://wa.me/message/BMD2CXV3YEX6C1';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
