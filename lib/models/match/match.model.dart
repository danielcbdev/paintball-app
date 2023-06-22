class MatchModel {
  double? individualPrice;
  List<Player>? players;

  MatchModel({
    this.individualPrice,
    this.players,
  });

  MatchModel.fromJson(Map<String, dynamic> json)
      : individualPrice = json['individual_price'] as double?,
        players = (json['players'] as List?)?.map((dynamic e) => Player.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'individual_price' : individualPrice,
    'players' : players?.map((e) => e.toJson()).toList()
  };
}

class Player {
  final int? index;
  final String? name;
  final List<double>? recharges;

  Player({
    this.index,
    this.name,
    this.recharges,
  });

  Player.fromJson(Map<String, dynamic> json)
      : index = json['index'] as int?,
        name = json['name'] as String?,
        recharges = (json['recharges'] as List?)?.map((dynamic e) => e as double).toList();

  Map<String, dynamic> toJson() => {
    'index' : index,
    'name' : name,
    'recharges' : recharges
  };
}
