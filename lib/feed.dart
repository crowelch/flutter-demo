import 'dart:async';
import 'dart:convert';

import 'package:demo/data/item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

final List<Item> _savedItems = new List<Item>();

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => new _FeedState();
}

class _FeedState extends State<Feed> {
  final String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  bool isLoading = true;
  List<Item> items = new List<Item>();
  Container emptyWidget = new Container();
  CircularProgressIndicator progressIndicator = new CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter News'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.list), onPressed: _onFavoritesClick),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return new Row(item: items[index]);
              }),
          new Center(
            child: showLoadingIndicator(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  void refreshFeed() {
    if (!isLoading) {
      loadFeed();
    }
  }

  loadFeed() async {
    setState(() {
      isLoading = true;
    });

    await http
        .read(_baseUrl + '/topstories.json?orderBy=\"\$key\" &limitToFirst=25')
        .then(getItems)
        .then(addItems);
  }

  addItems(List<Item> newItems) {
    setState(() {
      items.clear();
      items.addAll(newItems);
      isLoading = false;
    });
  }

  displayError() {
    setState(() {
      //TODO: Display error state
      print('problem loading data');
      isLoading = false;
    });
  }

  Future<List<Item>> getItems(String rawIds) async {
    List<dynamic> ids = jsonDecode(rawIds);
    Completer<List<Item>> completer = new Completer<List<Item>>();

    await Future.wait(ids.map((id) => http
            .read(_baseUrl + '/item/' + id.toString() + '.json')
            .then((value) => Item.fromJson(jsonDecode(value)))))
        .then((value) => completer.complete(value));

    return completer.future;
  }

  Widget showLoadingIndicator() {
    return isLoading ? progressIndicator : emptyWidget;
  }

  void _onFavoritesClick() {
    Navigator.of(context)
        .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedItems.map((Item item) {
        return new ListTile(
          title: new Text(item.title),
          onTap: () {
            _launchURL(url: item.url);
          },
        );
      });
      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();
      return new Scaffold(
        appBar: new AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: new ListView(children: divided),
      );
    }));
  }

  _launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Row extends StatefulWidget {
  final Item item;

  Row({this.item});

  @override
  RowState createState() => new RowState();
}

class RowState extends State<Row> {
  @override
  Widget build(BuildContext context) {
    return _buildRow();
  }

  Widget _buildRow() {
    final alreadySaved = _savedItems.contains(widget.item);
    return new ListTile(
      title: Text(widget.item.title),
      trailing: GestureDetector(
        child: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _savedItems.remove(widget.item);
            } else {
              _savedItems.add(widget.item);
            }
          });
        },
      ),
      onTap: () {
        _launchURL(url: widget.item.url);
      },
    );
  }

  _launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
