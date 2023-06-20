class FidelityCardConfigModel {
  final int? maxPoints;
  final String? award;

  FidelityCardConfigModel({
    this.maxPoints,
    this.award,
  });

  FidelityCardConfigModel.fromJson(Map<String, dynamic> json)
      : maxPoints = json['max_points'] as int?,
        award = json['award'] as String?;

  Map<String, dynamic> toJson() => {
    'max_points' : maxPoints,
    'award' : award
  };
}
