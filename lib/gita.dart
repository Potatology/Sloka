import 'dart:convert' as convert;

class Gita {
  Map<String, dynamic> chapters;

  Gita({this.chapters});

  Gita.empty() {
    this.chapters = {};
    for (var i = 1; i < 19; i++) {
      this.chapters[i.toString()] = [];
    }
  }

  factory Gita.fromJson(json) {
    return Gita(chapters: json);
  }
}

class Sloka {
  String title;
  String sanskrit;
  String transliteration;
  Map<String, dynamic> dict;
  String translation;

  Sloka(
      {this.title,
      this.sanskrit,
      this.transliteration,
      this.dict,
      this.translation});

  factory Sloka.fromJson(json) {
    var sloka = Sloka(
        title: json['title'] ?? null,
        sanskrit: json['sanskrit'] ?? null,
        translation: json['literary_trans'] ?? null,
        dict: json['words_trans'] ?? null,
        transliteration: json['transliteration'] ?? null);
    return sloka;
  }
}
