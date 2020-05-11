import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AgendarReuniao extends StatefulWidget {
  @override
  _AgendarReuniaoState createState() => _AgendarReuniaoState();
}

class _AgendarReuniaoState extends State<AgendarReuniao> {

  final _itemController = TextEditingController();
  final _participanteController = TextEditingController();

  List _itensDePauta = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  List _participante = [];
  Map<String, dynamic> _lastRemoved2;
  int _lastRemoved2Pos;


  @override
  void initState() {
    super.initState();
    
    _readData().then((data){
      setState(() {
        _itensDePauta = json.decode(data);
      });
    });
  }

  void _addItem(){
    setState(() {
      Map<String, dynamic> newItem = Map();
      newItem["title"] = _itemController.text;
      _itemController.text = "";
      newItem["ok"] = false;
      _itensDePauta.add(newItem);
      _savedData();
    });
  }

  void _addParticipante(){
    setState(() {
      Map<String, dynamic> newParticipante = Map();
      newParticipante["title"] = _participanteController.text;
      _participanteController.text = "";
      newParticipante["ok"] = false;
      _participante.add(newParticipante);
      _savedData();
    });
  }

  var selectedType;

  List<String> _meetingType = <String>[
    'Ordinária',
    'Extraordinária',
    'Continuidade'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Agendar Reunião", style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Botoes de tipo reuniao e usuario cadastrador
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.0,),
              SizedBox(width: 10.0,),
              // Texto tipo de reunião
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  //color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text("Tipo de reunião", style: TextStyle(
                    color: Colors.brown,
                    fontSize: 15.0
                ),),
              ),
              SizedBox(height: 20.0,),
              // Selecionar tipo de reunião
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: DropdownButton(
                    items: _meetingType
                        .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.brown),
                      ),
                      value: value,
                    ))
                        .toList(),
                    onChanged: (selectedMeetingType){
                      print('$selectedMeetingType');
                      setState(() {
                        selectedMeetingType = selectedMeetingType;
                      });
                      setState(() {
                        selectedType = selectedMeetingType;
                      });
                    },
                    value: selectedType,
                    isExpanded: false,
                    hint: Text('Selecione tipo de reunião',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Dados de data e hora do agendamento de reuniao
          // Texto "Identificação da reunião"
          Center(
            child: Text("Identificação da reunião", style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
          // COLOCAR UMA LINHA AQUI DIVIDER(),
          SizedBox(height: 20.0,),
          // TEXTO DATA/HORA
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text Data e hora
                Container(
                  width: 100.0,
                  height: 50.0,
                  //color: Colors.brown[100],
                  child: Center(
                    child: Text("Data/Hora", style: TextStyle(
                        color: Colors.brown,
                        fontSize: 15.0
                    ),),
                  ),
                ),
                // Campo de data e hora
                SizedBox(width: 5.0,),
                // ------------------------ INSERIR DATA
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 10.0),
                    height: 30.0,
                    color: Colors.brown[50],
                    child: Center(
                      child: TextField(
                        //autofocus: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.brown[300],
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                            hintText: "Insira data"
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0,),
                // ------------------------ TEXTO HORA INICIO
                Container(
                  width: 100.0,
                  height: 50.0,
                  //color: Colors.brown[100],
                  child: Center(
                    child: Text("Inicio", style: TextStyle(
                        color: Colors.brown,
                        fontSize: 15.0
                    ),),
                  ),
                ),
                // campo de hora inicio
                SizedBox(width: 5.0,),
                // ------------------------ INSERIR HORA INICIO
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 10.0),
                    height: 30.0,
                    color: Colors.brown[50],
                    child: Center(
                      child: TextField(
                        //autofocus: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.brown[300],
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                            hintText: "HH : MM"
                        ),
                      ),
                    ),
                  ),
                ),
                // campo de hora fim
                SizedBox(width: 5.0,),
                // ------------------------ TEXTO HORA FINAL
                Container(
                  width: 60.0,
                  height: 50.0,
                  //color: Colors.brown[100],
                  child: Center(
                    child: Text("Até", style: TextStyle(
                        color: Colors.brown,
                        fontSize: 15.0
                    ),),
                  ),
                ),
                SizedBox(width: 5.0,),
                // ------------------------ INSERIR HORA FINAL
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 10.0),
                    height: 30.0,
                    color: Colors.brown[50],
                    child: Center(
                      child: TextField(
                        //autofocus: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.brown[300],
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                            hintText: "HH : MM"
                        ),
                      ),
                    ),
                  ),
                ),
                // text local
                SizedBox(width: 5.0,),
                // ------------------------ LOCAL DE REUNIÃO
                Container(
                  width: 150.0,
                  height: 30.0,
                  //color: Colors.brown[100],
                  child: Center(
                    child: Text(
                      "Local de reunião", style: TextStyle(
                      color: Colors.brown,

                    ),
                    ),
                  ),
                ),
                // Campo de colocar local
                SizedBox(width: 5.0,),
                // ------------------------ INSERIR LOCAL DE REUNIÃO
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 10.0),
                    height: 30.0,
                    color: Colors.brown[50],
                    child: Center(
                      child: TextField(
                        //autofocus: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.brown[300],
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                            hintText: "Local de reunião"
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0,),
          // ------------------------ TEXTO OBJETIVOS
          Center(
            child: Text("Objetivos", style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
          // ------------------------ TEXTO OBJETIVO DA REUNIÃO
          // ------------------------ INSERIR OBJETIVO DA REUNIÃO
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 50.0,
                  child: Center(
                    child: Text("Objetivo", style: TextStyle(
                      color: Colors.brown,
                      fontSize: 15.0,
                    ),),
                  ),
                ),
                // ------------------------ INSERIR OBJETIVO DA REUNIÃO
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 10.0),
                    height: 30.0,
                    color: Colors.brown[50],
                    child: Center(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.brown[400],
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                          hintText: "Informe objetivo para a reunião",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dados pauta e itens de pauta
          // ------------------------ TEXTO RESPONSÁVEL REUNIÃO
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 50.0,
                  child: Center(
                    child: Text("Responsável", style: TextStyle(
                      color: Colors.brown,
                      fontSize: 15.0,
                    ),),
                  ),
                ),
                // ------------------------ NOME DO RESPONSÁVEL REUNIÃO
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 10.0),
                    height: 30.0,
                    color: Colors.brown[50],
                    child: Center(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.brown[400],
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                          hintText: "Nome do responsável pela reunião",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ------------------------ TEXTO PAUTA DA REUNIÃO
          Container(
            child: Column(
              children: [
                // TEXTO PAUTA, TEXTFIELD ADD ITEM DE PAUTA, BOTAO ADD
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.0,
                      height: 50.0,
                      child: Center(
                        child: Text("Pauta", style: TextStyle(
                          color: Colors.brown,
                          fontSize: 15.0,
                        ),),
                      ),
                    ),
                    // ------------------------ INSERIR ITENS DE PAUTA
                    Expanded(
                      child: Container(
                        height: 30.0,
                        color: Colors.brown[50],
                        child: Center(
                          child: TextField(
                            controller: _itemController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.brown[400],
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              hintText: "Novo item da pauta",
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ------------------------ BOTAO ADICIONAR ITEM DE PAUTA
                    Container(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      width: 70.0,
                      height: 30.0,
                      child: FlatButton(
                        onPressed: _addItem,
                        color: Colors.brown[200],
                        child: Text("ADD", style: TextStyle(
                            color: Colors.brown,
                            fontSize: 12.0
                        ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ------------------------ LISTVIEW
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
                itemCount: _itensDePauta.length,
                itemBuilder: buildItem
            ),
          ),
          // ------------------------ PARTICIPANTES
          Container(
            child: Column(
              children: [
                // TEXTO PARTICIPANTE, TEXTFIELD ADD PARTICIPANTE DE PAUTA, BOTAO ADD
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.0,
                      height: 50.0,
                      child: Center(
                        child: Text("Participantes", style: TextStyle(
                          color: Colors.brown,
                          fontSize: 15.0,
                        ),),
                      ),
                    ),
                    // ------------------------ INSERIR PARTICIPANTE
                    Expanded(
                      child: Container(
                        height: 30.0,
                        color: Colors.brown[50],
                        child: Center(
                          child: TextField(
                            controller: _participanteController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.brown[400],
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              hintText: "Inserir participante",
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ------------------------ BOTAO ADICIONAR PARTICIPANTE
                    Container(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      width: 70.0,
                      height: 30.0,
                      child: FlatButton(
                        onPressed: _addParticipante,
                        color: Colors.brown[200],
                        child: Text("ADD", style: TextStyle(
                            color: Colors.brown,
                            fontSize: 12.0
                        ),),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.0),
                      itemCount: _participante.length,
                      itemBuilder: buildParticipante
                  ),
                ),
              ],
            ),
          ),
          // ------------------------ LISTVIEW
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _itensDePauta.length,
                itemBuilder: buildItem
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_itensDePauta[index]["title"]),
        value: _itensDePauta[index]["ok"],
        //secondary: CircleAvatar(
        //child: Icon(_itensDePauta[index]["ok"] ?
        //Icons.check : Icons.error),
        //),
        onChanged: (c) {
          setState(() {
            _itensDePauta[index]["ok"] = c;
            _savedData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_itensDePauta[index]);
          _lastRemovedPos = index;
          _itensDePauta.removeAt(index);

          _savedData();

          final snack = SnackBar(
            content: Text("Item \"${_lastRemoved["title"]}\" removido"),
            action: SnackBarAction(label: "Desfazer",
            onPressed: () {
              setState(() {
                _itensDePauta.insert(_lastRemovedPos, _lastRemoved);
                _savedData();
              });
            }),
            duration: Duration(seconds: 4),
          );

          Scaffold.of(context).showSnackBar(snack);
          }
        );
      },
    );
  }

  Widget buildParticipante(context, index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_participante[index]["title"]),
        value: _participante[index]["ok"],
        //secondary: CircleAvatar(
        //child: Icon(_itensDePauta[index]["ok"] ?
        //Icons.check : Icons.error),
        //),
        onChanged: (c) {
          setState(() {
            _participante[index]["ok"] = c;
            _savedData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved2 = Map.from(_itensDePauta[index]);
          _lastRemoved2Pos = index;
          _participante.removeAt(index);

          _savedData();

          final snack = SnackBar(
            content: Text("Item \"${_lastRemoved["title"]}\" removido"),
            action: SnackBarAction(label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _itensDePauta.insert(_lastRemovedPos, _lastRemoved);
                    _savedData();
                  });
                }),
            duration: Duration(seconds: 4),
          );

          Scaffold.of(context).showSnackBar(snack);
        }
        );
      },
    );
  }
  // Obter arquivo
  Future<File> _getFile()  async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }
  // pega a lista, transformando a lista em um json e armazenando
  // numa String data

  // Salvar dados no arquivo
  Future<File> _savedData() async {
    String data = json.encode(_itensDePauta);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  // Ler arquivo
  Future<String> _readData() async {
    try{
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
