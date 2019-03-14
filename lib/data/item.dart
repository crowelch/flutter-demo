import 'package:demo/data/Favorite.dart';

class Item {
  int id;
  String type;
  String by;
  int time;
  String text;
  int parent;
  int poll;
  List kids;
  String url;
  int score;
  String title;
  List parts;
  int descendants;

  Item(
      this.id,
      this.type,
      this.by,
      this.time,
      this.text,
      this.parent,
      this.poll,
      this.kids,
      this.url,
      this.score,
      this.title,
      this.parts,
      this.descendants);

  Item.fromFavorite(Favorite favorite) {
    this.id = favorite.id;
    this.type = favorite.type;
    this.by = favorite.by;
    this.time = favorite.time;
    this.kids = favorite.kids;
    this.url = favorite.url;
    this.score = favorite.score;
    this.title = favorite.title;
    this.descendants = favorite.descendants;
  }

  Item.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        type = json['type'],
        by = json['by'],
        time = json['time'],
        kids = json['kids'],
        url = json['url'],
        score = json['score'],
        title = json['title'],
        descendants = json['descendants'];
}
