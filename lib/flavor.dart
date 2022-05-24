class Flavor {
  final String NameFlavor;
  final bool isFavorite;
  int Id = 0;
  Flavor({required this.NameFlavor, this.isFavorite = false, required this.Id});

  Flavor copyWith({int? Id, String? name, bool? isFavorite}) => Flavor(
      NameFlavor: name ?? this.NameFlavor,
      isFavorite: isFavorite ?? this.isFavorite,
      Id: Id ?? this.Id);

  @override
  String toString() {
    // TODO: implement toString
    return ' NameFlavor: $NameFlavor isFavorite: $isFavorite ';
  }
}
//SELECT id, TextTask, IsExec FROM [tasks]