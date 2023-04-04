import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class editarPalavra extends StatefulWidget {
  final WordPair? wordPair;
  const editarPalavra({Key? key, this.wordPair}) : super(key: key);

  @override
  _editarPalavraState createState() => _editarPalavraState();
}

class _editarPalavraState extends State<editarPalavra> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.wordPair?.asPascalCase ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WordPair? selectedWord =
        ModalRoute.of(context)?.settings.arguments as WordPair?;

    _controller.text = selectedWord?.asPascalCase ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Editar Palavra'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  WordPair editedWord = WordPair(_controller.text, " ");
                  Navigator.pop(context, editedWord);
                } else {
                  // Mostra uma mensagem de erro para o usuário
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Erro'),
                      content: Text('A palavra não pode estar vazia.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
