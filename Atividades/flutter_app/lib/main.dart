import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:first_flutter_app/editarPalavra.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(primaryColor: Colors.white),
      routes: {
        '/editPalavra': (context) => editarPalavra(),
      },
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class WordRepository {
  final List<WordPair> words = generateWordPairs().take(20).toList();
}

class RandomWordsState extends State<RandomWords> {
  final WordRepository _wordRepository = WordRepository();
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  WordPair? _selectedWord;
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          IconButton(
              icon: _isGridView
                  ? const Icon(Icons.view_list)
                  : const Icon(Icons.grid_on),
              onPressed: _toggleView),
        ],
      ),
      body: _isGridView ? _buildGrid() : _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }
          final int index = i ~/ 2;
          if (index >= _wordRepository.words.length) {
            _wordRepository.words.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_wordRepository.words[index]);
        });
  }

  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      children: _wordRepository.words.map((WordPair pair) {
        return _buildRow(pair);
      }).toList(),
    );
  }

  Widget _buildRow(WordPair pair) {
    if (_selectedWord == null) {
      _selectedWord = pair;
    }
    final bool alreadySaved = _saved.contains(pair);

    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedWord = pair;
        });
        final editedWord = await Navigator.of(context)
            .pushNamed('/editPalavra', arguments: _selectedWord);
        if (editedWord != null && editedWord is WordPair) {
          setState(() {
            _wordRepository.words[_wordRepository.words.indexOf(pair)] =
                editedWord;
          });
        }
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
              trailing: IconButton(
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(pair);
                    } else {
                      _saved.add(pair);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _removeSaved(pair);
                    });
                  },
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white, // define a cor do ícone como branca
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    ).then((value) => setState(() {}));
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  //remover palavras
  void _removeSaved(WordPair pair) {
    _saved.remove(pair);
    _pushSaved();
  }
}
