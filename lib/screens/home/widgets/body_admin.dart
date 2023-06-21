import 'package:flutter/material.dart';
import 'package:picospaintballzone/models/user/user.model.dart';

class BodyAdminWidget extends StatefulWidget {
  const BodyAdminWidget({Key? key, required this.user}) : super(key: key);
  final UserModel? user;

  @override
  State<BodyAdminWidget> createState() => _BodyAdminWidgetState();
}

class _BodyAdminWidgetState extends State<BodyAdminWidget> {
  @override
  Widget build(BuildContext context) {
    return Text('tela de admin');
  }
}
