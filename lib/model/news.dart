class News {
  final String id;
  final String title;
  final String img;
  final String text;
  News(
      {required this.id,
      required this.title,
      required this.img,
      required this.text});

  factory News.fromJson(Map<String, dynamic> parsedJson) {
    return News(
        id: parsedJson['id'],
        title: parsedJson['title'],
        img: parsedJson['img'],
        text: parsedJson['text']);
  }
}
