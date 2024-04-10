// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=58e880d2";

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Conversao extends StatelessWidget {
  final TextEditingController moeda1Controller = TextEditingController();
  final TextEditingController moeda2Controller = TextEditingController();
  final TextEditingController nomeMoeda1Controller = TextEditingController();
  final TextEditingController nomeMoeda2Controller = TextEditingController();

  final List<String> valores = [
    "BRL",
    "USD",
    "EUR",
    "JPY",
    "GBP",
    "ARS",
    "CAD",
    "AUD",
    "CNY",
    "BTC"
  ];

  double moeda1 = 1.00;
  double moeda2 = 0;

  String nomeMoeda1 = "BRL";
  String nomeMoeda2 = "USD";

  Map<String, dynamic> list = Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    return telaConversao();
  }

  void _nomeMoeda1Change(String value) {
    if (value == nomeMoeda2) {
      String nomeAux = nomeMoeda1;
      nomeMoeda1 = "";
      _nomeMoeda2Change(nomeAux);
      nomeMoeda2Controller.text = nomeAux;
    }
    nomeMoeda1 = value;
    if (nomeMoeda1 == "BRL") {
      moeda1 = 1.00;
    } else {
      moeda1 = list[nomeMoeda1]["buy"];
    }
    _moeda1Change(moeda1Controller.text);
  }

  void _nomeMoeda2Change(String value) {
    if (value == nomeMoeda1) {
      String nomeAux = nomeMoeda2;
      nomeMoeda2 = "";
      _nomeMoeda1Change(nomeAux);
      nomeMoeda1Controller.text = nomeAux;
    }
    nomeMoeda2 = value;
    if (nomeMoeda2 == "BRL") {
      moeda2 = 1.00;
    } else {
      moeda2 = list[nomeMoeda2]["buy"];
    }
    _moeda2Change(moeda2Controller.text);
  }

  void _moeda1Change(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double moeda1 = double.parse(text);
    moeda2Controller.text = (moeda1 * this.moeda1 / moeda2).toStringAsFixed(2);
  }

  void _moeda2Change(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double moeda2 = double.parse(text);
    moeda1Controller.text = (moeda2 * this.moeda2 / moeda1).toStringAsFixed(2);
  }

  void _clearAll() {
    moeda1Controller.text = "";
    moeda2Controller.text = "";
  }

  Widget telaConversao() {
    return FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                  child: Text(
                "Carregando dados...",
                style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  "Erro ao carregar dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              } else {
                list = snapshot.data!["results"]["currencies"];
                moeda2 = list[nomeMoeda2]["buy"];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(Icons.monetization_on,
                          size: 100.0, color: Colors.amber),
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: buildSelectFormField(valores, 0,
                              _nomeMoeda1Change, nomeMoeda1Controller),
                        ),
                        Expanded(
                          child: buildTextFormField(
                              moeda1Controller, _moeda1Change),
                        ),
                      ]),
                      const Divider(),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: buildSelectFormField(valores, 1,
                                _nomeMoeda2Change, nomeMoeda2Controller),
                          ),
                          Expanded(
                              child: buildTextFormField(
                                  moeda2Controller, _moeda2Change)),
                        ],
                      )
                    ],
                  ),
                );
              }
          }
        });
  }

  Widget buildTextFormField(TextEditingController controller, Function f) {
    return TextField(
      onChanged: (value) => f(value),
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 2.0),
        ),
      ),
      style: const TextStyle(color: Colors.amber),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget buildSelectFormField(List<String> valores, int index, Function f,
      TextEditingController controller) {
    return DropdownMenu<String>(
      initialSelection: valores[index],
      label: const Text('Moeda'),
      controller: controller,
      onSelected: (String? moeda) {
        f(moeda);
      },
      dropdownMenuEntries: valores.map<DropdownMenuEntry<String>>((valor) {
        return DropdownMenuEntry<String>(
          value: valor,
          label: valor,
          style: MenuItemButton.styleFrom(
            foregroundColor: Colors.amber,
          ),
        );
      }).toList(),
    );
  }
}
