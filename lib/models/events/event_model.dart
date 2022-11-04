// create event model

class Event {
  int? id;
  String name;
  DateTime date;
  String? description;
  String? location;
  String? image;
  bool? isDeleted;
  DateTime? deletedAt;

  Event({
    this.id,
    required this.name,
    required this.date,
    this.description,
    this.location,
    this.image,
    this.isDeleted = false,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'description': description,
      'location': location,
      'image': image,
      "isDeleted": isDeleted == true ? 1 : 0,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  Event copyWith({
    int? id,
    String? name,
    DateTime? date,
    String? description,
    String? location,
    String? image,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      description: description ?? this.description,
      location: location ?? this.location,
      image: image ?? this.image,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

// create event history

class EventRestoreHistory {
  int? id;
  DateTime date;
  int eventId;

  EventRestoreHistory({
    this.id,
    required this.date,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'eventId': eventId,
    };
  }
}
