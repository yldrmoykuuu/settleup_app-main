class GroupModel {
  final String id;
  final String name;
  final List<String> members;
  final Map<String, double> balances;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.balances,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupModel(
      id: id,
      name: map['name'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      balances: Map<String, double>.from(
        (map['balances'] ?? {}).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'members': members, 'balances': balances};
  }
}
