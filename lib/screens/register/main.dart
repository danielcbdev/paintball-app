import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_event.dart';
import 'package:picospaintballzone/bloc/auth/auth_state.dart';
import 'package:picospaintballzone/screens/home/main.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';
import 'package:picospaintballzone/shared/widgets/primary_button.dart';
import 'package:picospaintballzone/shared/widgets/primary_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _controllerName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerCpf = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerRePassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const AutoSizeText(
          'Cadastre-se',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state){
              if(state is DoneRegisterUserState){
                Utils.showMessageDialog(context: context, txt: 'Usuário cadastrado com sucesso!', isSuccess: true,);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const HomeScreen(),
                  ),
                );
              }
            },
            builder: (context, state){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    PrimaryTextField(
                      labelText: 'Nome completo',
                      backgroundColor: Colors.white,
                      controller: _controllerName,
                      isRequired: true,
                      enabled: state is! LoadingAuthState,
                      onChanged: (value){},
                      type: PrimaryTextfieldType.text,
                    ),
                    const SizedBox(height: 10,),
                    PrimaryTextField(
                      labelText: 'Telefone (WhatsApp de preferência)',
                      backgroundColor: Colors.white,
                      controller: _controllerPhone,
                      isRequired: true,
                      enabled: state is! LoadingAuthState,
                      onChanged: (value){},
                      type: PrimaryTextfieldType.phone,
                    ),
                    const SizedBox(height: 10,),
                    PrimaryTextField(
                      labelText: 'E-mail',
                      backgroundColor: Colors.white,
                      controller: _controllerEmail,
                      isRequired: true,
                      enabled: state is! LoadingAuthState,
                      onChanged: (value){},
                      type: PrimaryTextfieldType.email,
                    ),
                    const SizedBox(height: 10,),
                    PrimaryTextField(
                      labelText: 'CPF',
                      backgroundColor: Colors.white,
                      controller: _controllerCpf,
                      enabled: state is! LoadingAuthState,
                      isRequired: true,
                      onChanged: (value){},
                      type: PrimaryTextfieldType.cpf,
                    ),
                    const SizedBox(height: 10,),
                    PrimaryTextField(
                      labelText: 'Senha',
                      backgroundColor: Colors.white,
                      controller: _controllerPassword,
                      enabled: state is! LoadingAuthState,
                      isRequired: true,
                      onChanged: (value){},
                      type: PrimaryTextfieldType.password,
                    ),
                    const SizedBox(height: 10,),
                    PrimaryTextField(
                      labelText: 'Confirmação de senha',
                      backgroundColor: Colors.white,
                      controller: _controllerRePassword,
                      enabled: state is! LoadingAuthState,
                      isRequired: true,
                      onChanged: (value){},
                      type: PrimaryTextfieldType.password,
                    ),
                    const SizedBox(height: 50,),
                    PrimaryButton(
                      text: 'Cadastrar',
                      isEnabled: state is! LoadingAuthState,
                      isLoading: state is LoadingAuthState,
                      color: AppColors.primaryColor,
                      textColor: Colors.white,
                      press: () async {
                        if(!_validateFields()){
                          Utils.showMessageDialog(context: context, txt: 'Por favor, preencha todas as informações!', isSuccess: false,);
                        } else if(_controllerPassword.text != _controllerRePassword.text) {
                          Utils.showMessageDialog(context: context, txt: 'A senha e a confirmação de senha são diferentes!', isSuccess: false,);
                        } else{
                          BlocProvider.of<AuthBloc>(context).add(
                            RegisterUserEvent(
                              name: _controllerName.text,
                              phone: _controllerPhone.text,
                              cpf: _controllerCpf.text,
                              email: _controllerEmail.text,
                              password: _controllerPassword.text,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30,),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool _validateFields() => _controllerName.text.isNotEmpty && _controllerPhone.text.isNotEmpty && _controllerEmail.text.isNotEmpty && _controllerCpf.text.isNotEmpty && _controllerPassword.text.isNotEmpty && _controllerRePassword.text.isNotEmpty;
}
