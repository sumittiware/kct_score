class Department {
  String name;
  int score;
  int id;

  Department({
    required this.name,
    required this.score,
    required this.id,
  });
}

Department fromJSONDep(Map<String, dynamic> mp) {
  return Department(
    name: mp['name'],
    score: mp['score'] ?? 0,
    id: mp['id'] ?? 0,
  );
}

List<Department> fromJSON(List<dynamic> mp) {
  List<Department> dep = [];

  mp.forEach((element) {
    dep.add(fromJSONDep(element));
  });

  return dep;
}
