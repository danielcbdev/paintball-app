import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_event.dart';
import 'package:picospaintballzone/bloc/auth/auth_state.dart';
import 'package:picospaintballzone/bloc/user/user_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_event.dart';
import 'package:picospaintballzone/bloc/user/user_state.dart';
import 'package:picospaintballzone/screens/login/main.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';

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
            builder: (context, state){
              if(state is LoadingUserState){
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
              } else if(state is ErrorUserState){
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
              } else if(state is DoneGetUserState){
                return Text(state.user.name ?? '');
              }
              return const Center();
            },
          ),
        ),
      ),
    );
  }
}
