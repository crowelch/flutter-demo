import 'package:demo/data/item.dart';

class Favorite {
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

  Favorite(
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

  Favorite.fromItem(Item item) {
    this.id = item.id;
    this.type = item.type;
    this.by = item.by;
    this.time = item.time;
    this.kids = item.kids;
    this.url = item.url;
    this.score = item.score;
    this.title = item.title;
    this.descendants = item.descendants;
  }
}
