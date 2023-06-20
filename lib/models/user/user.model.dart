class UserModel {
  final String? uid;
  final String? email;
  final String? name;
  final int? qtdPoints;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.qtdPoints,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as String?,
        email = json['email'] as String?,
        name = json['name'] as String?,
        qtdPoints = json['qtd_points'] as int?;

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'email' : email,
    'name' : name,
    'qtd_points' : qtdPoints
  };
}
