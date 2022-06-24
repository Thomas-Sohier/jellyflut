class ProviderIds {
  ProviderIds({
    this.imdb,
    this.tvdb,
    this.zap2It,
  });

  String? imdb;
  String? tvdb;
  String? zap2It;

  factory ProviderIds.fromMap(Map<String, dynamic> json) => ProviderIds(
        imdb: json['Imdb'],
        tvdb: json['Tvdb'],
        zap2It: json['Zap2It'],
      );

  Map<String, dynamic> toMap() => {
        'Imdb': imdb,
        'Tvdb': tvdb,
        'Zap2It': zap2It,
      };
}
