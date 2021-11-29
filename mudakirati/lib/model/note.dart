class Note {
  final dynamic id;
  final bool? completed;
  final String? title, content, createdAt, updatedAt;
  const Note({
    this.id,
    this.completed,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });
  const Note.c({
    this.id,
    this.completed,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
  });
}
