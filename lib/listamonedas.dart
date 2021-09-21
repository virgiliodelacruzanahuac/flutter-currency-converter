import 'package:flutter/material.dart';
import 'obtienedatosapi.dart';

class listamonedas extends StatefulWidget {
  @override
  _listamonedasState createState() => _listamonedasState();
}

class _listamonedasState extends State<listamonedas> {
  List<String> alphabets = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  void temp() async {
    print('Floating Action Button Clicked');
    obtienedatosapi c = obtienedatosapi();
    Map monedas = await c.getdatos();
    List<String> a = [];
    a.clear();
    for (var k in monedas.keys) {
      String r = "${monedas[k]},$k";
      print(r);
      a.add(r);
    }
    setState(() {
      alphabets.clear();
      alphabets = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('Floating Action Button Above ListView')),
      body: ListView.builder(
          itemCount: alphabets.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              margin: EdgeInsets.all(2),
              color: Colors.lightGreen,
              child: Center(
                  child: Text(
                '${alphabets[index]}',
                style: TextStyle(fontSize: 24, color: Colors.white),
              )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => temp(),
      ),
    ));
  }
}
