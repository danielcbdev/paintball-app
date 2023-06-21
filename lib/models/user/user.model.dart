class UserModel {
  final String? uid;
  final String? email;
  final String? name;
  final String? cpf;
  final int? qtdPoints;
  final bool? isAdm;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.cpf,
    this.qtdPoints,
    this.isAdm,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as String?,
        email = json['email'] as String?,
        name = json['name'] as String?,
        cpf = json['cpf'] as String?,
        qtdPoints = json['qtd_points'] as int?,
        isAdm = json['is_adm'] as bool?;

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'email' : email,
    'name' : name,
    'cpf' : cpf,
    'qtd_points' : qtdPoints,
    'is_adm' : isAdm,
  };
}
