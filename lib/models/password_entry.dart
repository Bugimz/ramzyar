class PasswordEntry {
  final int? id;
  final String title;
  final String username;
  final String password;
  final String? website;
  final String? notes;
  final DateTime createdAt;

  PasswordEntry({
    this.id,
    required this.title,
    required this.username,
    required this.password,
    this.website,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  PasswordEntry copyWith({
    int? id,
    String? title,
    String? username,
    String? password,
    String? website,
    String? notes,
    DateTime? createdAt,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      website: website ?? this.website,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'website': website,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'] as int?,
      title: map['title'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      website: map['website'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
