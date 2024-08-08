class Achievement {
  Achievement({required this.name, required this.description});

  String name;
  String description;

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}
