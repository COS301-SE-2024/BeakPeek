class ProvinceData {
  factory ProvinceData.fromJson(Map<String, Object?> json) {
    return ProvinceData(
      id: json['id'] as int,
      easterncape: json['easterncape'] != null && json['easterncape'] == 1
          ? true
          : false,
      gauteng: json['gauteng'] != null && json['gauteng'] == 1 ? true : false,
      kwazulunatal: json['kwazulunatal'] != null && json['kwazulunatal'] == 1
          ? true
          : false,
      limpopo: json['limpopo'] != null && json['limpopo'] == 1 ? true : false,
      mpumalanga:
          json['mpumalanga'] != null && json['mpumalanga'] == 1 ? true : false,
      northerncape: json['northerncape'] != null && json['northerncape'] == 1
          ? true
          : false,
      northwest:
          json['northwest'] != null && json['northwest'] == 1 ? true : false,
      westerncape: json['westerncape'] != null && json['westerncape'] == 1
          ? true
          : false,
      freestate:
          json['freestate'] != null && json['freestate'] == 1 ? true : false,
    );
  }

  ProvinceData({
    required this.id,
    required this.easterncape,
    required this.gauteng,
    required this.kwazulunatal,
    required this.limpopo,
    required this.mpumalanga,
    required this.northerncape,
    required this.northwest,
    required this.westerncape,
    required this.freestate,
  });

  final int id;
  final bool easterncape;
  final bool gauteng;
  final bool kwazulunatal;
  final bool limpopo;
  final bool mpumalanga;
  final bool northerncape;
  final bool northwest;
  final bool westerncape;
  final bool freestate;

  @override
  String toString() {
    return '''ProvinceData(id: $id, easterncape: $easterncape, gauteng: $gauteng, kwazulunatal: $kwazulunatal, limpopo: $limpopo, '
        'mpumalanga: $mpumalanga, northerncape: $northerncape, northwest: $northwest, '
        'westerncape: $westerncape, freestate: $freestate)''';
  }
}
