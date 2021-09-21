import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'listamonedas.dart';

void main() => runApp(new MaterialApp(
      title: "Currency Converter",
      home: CurrencyConverter(),
    ));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String> currencies;
  List<String> currenciesdesc;

  String fromCurrency = "mxn";
  String toCurrency = "usd";
  String result;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    String uri =
        "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json";
    var response = await http.get(Uri.parse(uri));
    var responseBody = json.decode(response.body);
    Map curMap = responseBody;
    currencies = curMap.keys.toList();
    // currenciesdesc = curMap.values.toList();
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri =
        'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api/latest/currencies/' +
            fromCurrency +
            '/' +
            toCurrency +
            '.json';

    var response = await http.get(Uri.parse(uri));
    var responseBody = json.decode(response.body);
    setState(() {
      result =
          (double.parse(fromTextController.text) * (responseBody[toCurrency]))
              .toStringAsFixed(2);
    });
    print(result);
    return "Success";
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: fromTextController,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                        trailing: _buildDropDownButton(fromCurrency),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: _doConversion,
                      ),
                      ListTile(
                        title: Chip(
                          label: result != null
                              ? Text(
                                  result,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              : Text(""),
                        ),
                        trailing: _buildDropDownButton(toCurrency),
                      ),
                      //listamonedas()
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value),
                  ],
                ),
              ))
          .toList(),
      onChanged: (String value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value);
        } else {
          _onToChanged(value);
        }
      },
    );
  }
}
