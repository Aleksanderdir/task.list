class Flavor {
  final String name;
  final bool isFavorite;
int id = 0;
  Flavor({required this.name, this.isFavorite = false, required this.id });

  Flavor copyWith({int? id, String? name, bool? isFavorite }) => Flavor(
      name: name ?? this.name, isFavorite: isFavorite ?? this.isFavorite, id: id
      ?? this.id);

  @override
  String toString() {
    // TODO: implement toString
    return ' name: $name isFavorite: $isFavorite ';
  }
}
//SELECT id, TextTask, IsExec FROM [tasks]