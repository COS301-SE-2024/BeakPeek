class Province {
  Province({
    required this.id,
    required this.name,
    this.birds,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
      birds: json['birds'],
    );
  }

  final int id;
  final String name;
  final dynamic birds;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'birds': birds,
    };
  }
}
