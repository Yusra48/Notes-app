class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });

  factory Todo.fromString(String todoString) {
    final parts = todoString.split('|');
    if (parts.length != 2) {
      throw FormatException('Invalid Todo format');
    }
    final title = parts[0];
    final isDone = parts[1] == 'true';
    return Todo(
      title: title,
      isDone: isDone,
    );
  }

  @override
  String toString() {
    return '$title|$isDone';
  }
}
