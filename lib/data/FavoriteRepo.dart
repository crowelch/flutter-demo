import 'package:demo/data/Favorite.dart';
import 'package:demo/data/item.dart';

class FavoriteRepo {
  final _saved = <Favorite>[];

  List<Favorite> getFavorites() {
    return _saved;
  }

  void addFavorite({Item item}) {
    _saved.add(Favorite.fromItem(item));
  }

  void removeFavorite({Favorite favorite}) {
    _saved.remove(favorite);
  }
}
