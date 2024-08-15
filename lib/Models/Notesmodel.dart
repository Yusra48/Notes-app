
class Note {
  final String title;
  final String description;

  Note({
    required this.title,
    required this.description,
  });

  factory Note.fromString(String noteString) {
    final parts = noteString.split('|');
    return Note(
      title: parts[0],
      description: parts[1],
    );
  }

  @override
  String toString() {
    return '$title|$description';
  }
}
