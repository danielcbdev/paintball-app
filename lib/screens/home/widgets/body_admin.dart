import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_bloc.dart';
import 'package:picospaintballzone/bloc/user/user_state.dart';
import 'package:picospaintballzone/models/user/user.model.dart';
import 'package:picospaintballzone/screens/client/main.dart';
import 'package:picospaintballzone/shared/theme/colors.dart';
import 'package:picospaintballzone/shared/utils/utils.dart';
import 'package:picospaintballzone/shared/widgets/primary_textfield.dart';

class BodyAdminWidget extends StatefulWidget {
  const BodyAdminWidget({Key? key, required this.user}) : super(key: key);
  final UserModel? user;

  @override
  State<BodyAdminWidget> createState() => _BodyAdminWidgetState();
}

class _BodyAdminWidgetState extends State<BodyAdminWidget> {

  final _controllerSearchClient = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(),
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state){
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            PrimaryTextField(
              labelText: "Pesquisar cliente",
              enabled: true,
              backgroundColor: Colors.white,
              controller: _controllerSearchClient,
              type: PrimaryTextfieldType.text,
              hasPrefix: true,
              prefix: const Icon(Icons.search_rounded),
              onChanged: (value) {
                setState(() {});
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _controllerSearchClient.text.isEmpty
                  ? FirebaseFirestore.instance.collection('users').where('is_adm', isEqualTo: false).snapshots()
                  : FirebaseFirestore.instance.collection('users')
                  .where('name', isGreaterThanOrEqualTo: _controllerSearchClient.text.isEmpty ? 0 : _controllerSearchClient.text, isLessThan: _controllerSearchClient.text.isEmpty
                  ? null
                  : _controllerSearchClient.text.substring(0, _controllerSearchClient.text.length - 1) +
                  String.fromCharCode(
                    _controllerSearchClient.text.codeUnitAt(_controllerSearchClient.text.length - 1) + 1,
                  ),).where('is_adm', isEqualTo: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if((snapshot.data?.docs ?? []).isEmpty)
                      const AutoSizeText(
                        'Nenhum cliente encontrado!',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    else
                      AutoSizeText(
                        '${snapshot.data?.docs.length} ${(snapshot.data?.docs ?? []).length < 2 ? 'cliente cadastrado' : 'clientes cadastrados'}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    const SizedBox(height: 20,),
                    Column(
                      children: (snapshot.data?.docs ?? []).map((DocumentSnapshot document) {
                        return InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClientScreen(snapshotClient: document))),
                          child: Container(
                            width: Utils.getMaxWidth(context),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            margin: const EdgeInsets.only(bottom: 10),
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Nome: ${document['name']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      AutoSizeText(
                                        'E-mail: ${document['email']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      AutoSizeText(
                                        'CPF: ${document['cpf']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      AutoSizeText(
                                        'Quantidade de pontos: ${document['qtd_points']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: AppColors.primaryColor, size: 30,),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
