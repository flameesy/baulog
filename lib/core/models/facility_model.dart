class Facility {
  final int id;
  final String name;
  final String type;
  final String status;
  final String location;
  final String description;

  Facility({required this.id, required this.name, required this.type, required this.status, required this.location, required this.description});

  // Method for converting SQLite data into a Facility instance
  factory Facility.fromMap(Map<String, dynamic> json) => Facility(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    status: json['status'],
    location: json['location'],
    description: json['description'],
  );

  // Method for converting a Facility instance into a SQLite-friendly map
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'status': status,
    'location': location,
    'description': description,
  };
}
