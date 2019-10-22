import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  final _toDoController = TextEditingController();

  //Funcao que cria um map e adiciona o titulo e status da tarefa e depois eh
  //add a _toDoList ao clicar o botao
  void addToDo(){
   //SetState aqui eh necessario pois precisamos que seja detectado a adicao de um todo na lista.
    setState(() {
      //Maior parte das vezes trabalhando com JSON, usa-se Maps de String e dynamic
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Tenta ocupar a maior parte do espaco em quanto outros componentes
                //diminuem.
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                        )
                    ),
                    controller: _toDoController,
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: addToDo,
                ),

              ],
            ),
          ),
          Expanded(
            //ListView Builder eh pq se a lista for grande os itens que nao aparecem
            //so serao renderizados quando descer a lista
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: (context, index){
                  return CheckboxListTile(
                    title: Text(_toDoList[index]["title"]),
                    value: _toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(
                        // Se o ok for true vai marcar se nao vai deixar sem
                          _toDoList[index]["ok"]? Icons.check : Icons.error
                      ),
                    ),
                    onChanged: (c){
                      setState(() {
                        _toDoList[index]["ok"] = c;
                      });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  //Pega um diretorio para armazenar o arquivo de dados
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  //Salva os dados no arquivo
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file =  await _getFile();
    return file.writeAsString(data);
  }
  //Le os dados do Arquivo
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    }catch(e){
      return null;
    }
  }


}