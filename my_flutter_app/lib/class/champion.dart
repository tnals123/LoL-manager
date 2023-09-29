class Champion {
  final String id;
  final String name;
  final String image;

  Champion({required this.id, required this.name, required this.image});

  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      id: json['id'],
      name: json['name'],
      image: json['image']['full'],
    );
  }
}
