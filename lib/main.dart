import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red[100],
        ),
        home: Scaffold(
          body: RandomWords(),
        ));
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>(); // save user favorites
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: Drawer(
        child: Scaffold(
          appBar: AppBar(
            title: Text("User Suggestions"),
          ),
          body: Column(
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  _pushSaved();
                },
                child: Text("Show Favourites"),
              )
            ],
          ),
        ),
      ),
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          // Add 3 lines from here...
          new IconButton(
              icon: const Icon(Icons.favorite), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
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
        },
      ),
    );
  }

  _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair); // Add this line.
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      leading: new CircleAvatar(
        backgroundColor: Colors.cyan,
        child: Text(
          pair.asString.toUpperCase().substring(0, 1),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  // old, one widget center of the screen
  Center _buildSuggestion(WordPair wordPair) {
    return Center(
      child: Text(
        wordPair.asPascalCase,
        style: TextStyle(
          color: Colors.cyan,
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
