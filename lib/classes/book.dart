class Book {
  int id;
  String title;
  int status;
  String isbn;
  String ean;

  Book({
    required this.id,
    required this.title,
    required this.status,
    required this.isbn,
    required this.ean,
  });
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      isbn: json['isbn'],
      ean: json['ean'],
    );
  }
}
