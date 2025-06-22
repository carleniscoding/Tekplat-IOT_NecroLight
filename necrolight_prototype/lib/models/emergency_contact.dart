class EmergencyContact {
  final String id;
  final String name;
  final String contactNumber;
  final String relationship;
  final DateTime createdAt;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.relationship,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'relationship': relationship,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contactNumber'],
      relationship: json['relationship'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? contactNumber,
    String? relationship,
    DateTime? createdAt,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      relationship: relationship ?? this.relationship,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
