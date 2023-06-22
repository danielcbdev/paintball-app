class UserModel {
  final String? uid;
  final String? email;
  final String? name;
  final String? phone;
  final String? cpf;
  final int? qtdPoints;
  final bool? isAdm;
  final String? fcmToken;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.phone,
    this.cpf,
    this.qtdPoints,
    this.isAdm,
    this.fcmToken,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as String?,
        email = json['email'] as String?,
        name = json['name'] as String?,
        phone = json['phone'] as String?,
        cpf = json['cpf'] as String?,
        qtdPoints = json['qtd_points'] as int?,
        isAdm = json['is_adm'] as bool?,
        fcmToken = json['fcm_token'] as String?;

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'email' : email,
    'name' : name,
    'phone' : phone,
    'cpf' : cpf,
    'qtd_points' : qtdPoints,
    'is_adm' : isAdm,
    'fcm_token' : fcmToken,
  };
}
