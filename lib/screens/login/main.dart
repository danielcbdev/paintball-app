import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_bloc.dart';
import 'package:picospaintballzone/bloc/auth/auth_event.dart';
import 'package:picospaintballzone/bloc/auth/auth_state.dart';
import 'package:picospaintballzone/screens/home/main.dart';
import 'package:picospaintballzone/shared/constants/assets_constants.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';
import 'package:picospaintballzone/shared/widgets/primary_button.dart';
import 'package:picospaintballzone/shared/widgets/primary_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _textLogin = TextEditingController();
  final _textPassword = TextEditingController();
  bool _isRememberMe = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Flex(
        direction: Axis.vertical,
        children: [
          const Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                AutoSizeText(
                  "BEM-VINDO(A)!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  "Faça seu login para continuar\nusando o sistema",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: Utils.getMaxWidth(context),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        transform: Matrix4.translationValues(0.0, -80.0, 0.0),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: AppColors.primaryColorDark,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              AssetsConstants.logoPng,
                            ),
                          ),
                        ),
                      ),
                      PrimaryTextField(
                        labelText: "E-mail",
                        enabled: true,
                        onChanged: (value) {},
                        validator: (value) {
                          return;
                        },
                        controller: _textLogin,
                        type: PrimaryTextfieldType.text,
                        hasPrefix: true,
                        prefix: const Icon(Icons.person),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PrimaryTextField(
                        labelText: "Senha",
                        enabled: true,
                        onChanged: (value) {},
                        validator: (value) {
                          return;
                        },
                        controller: _textPassword,
                        type: PrimaryTextfieldType.password,
                        hasPrefix: true,
                        prefix: const Icon(Icons.lock_outline),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isRememberMe,
                                  onChanged: (value) => setState(() {
                                    _isRememberMe = value!;
                                  }),
                                ),
                                const Expanded(
                                  child: AutoSizeText(
                                    'Lembrar de mim',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => _showEmailConfirmation(),
                            child: const AutoSizeText(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is DoneLoginState) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } else if (state is ErrorAuthState) {
                            Utils.showMessageDialog(
                              context: context,
                              txt: state.message,
                              isSuccess: false,
                            );
                          }
                          // else if(state is DoneSendPasswordRecoveryState){
                          //   Utils.showMessageDialog(context: context, txt: 'E-mail de recuperação de senha enviado!', isSuccess: true,);
                          // }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return PrimaryButton(
                              text: "Entrar",
                              color: AppColors.primaryColor,
                              textColor: Colors.white,
                              isEnabled:
                              state is LoadingAuthState ? false : true,
                              isLoading:
                              state is LoadingAuthState ? true : false,
                              press: () {
                                if (_textLogin.text.isEmpty || _textPassword.text.isEmpty) {
                                  Utils.showMessageDialog(
                                    context: context,
                                    txt: 'Por favor, insira o e-mail e a senha para continuar!',
                                    isSuccess: false,
                                  );
                                } else {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    LoginEvent(
                                      email: _textLogin.text,
                                      password: _textPassword.text,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                        child: RichText(
                          text: const TextSpan(
                            text: 'É novo por aqui? ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: 'Cadastre-se',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmailConfirmation(){
    final controllerEmail = TextEditingController();

    Utils.showDialogUtil(
      context: context,
      title: 'Informe o e-mail',
      txtConfirmButton: "Enviar",
      txtCancelButton: 'Cancelar',
      onPressedCancel: () => Navigator.pop(context),
      isDismissible: true,
      onPressedConfirm: () {
        if(controllerEmail.text.isEmpty){
          Utils.showMessageDialog(context: context, txt: 'Por favor, informe o e-mail', isSuccess: false,);
        } else{
          // BlocProvider.of<AuthBloc>(context).add(SendPasswordRecoveryEvent(email: controllerEmail.text));
          Navigator.pop(context);
        }
      },
      content: PrimaryTextField(
        labelText: 'E-mail',
        controller: controllerEmail,
        enabled: true,
        isRequired: true,
        onChanged: (value){},
        type: PrimaryTextfieldType.email,
      ),
    );
  }
}
