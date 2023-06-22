import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_bloc.dart';
import 'package:picospaintballzone/bloc/fidelity-card/fidelity_card_bloc.dart';
import 'package:picospaintballzone/bloc/matches/matches_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_bloc.dart';

class BlocsLoad extends StatelessWidget {
  const BlocsLoad({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<FidelityCardBloc>(create: (context) => FidelityCardBloc()),
        BlocProvider<MatchesBloc>(create: (context) => MatchesBloc()),
      ],
      child: child,
    );
  }
}
