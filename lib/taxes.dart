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

class Taxes extends StatelessWidget {
  late List<dynamic> list;

  @override
  Widget build(BuildContext context) {
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
                list = snapshot.data!["results"]["taxes"];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Taxas"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data: ' + list[0]["date"].toString()),
                            Text('Fator Diário: ' +
                                list[0]["daily_factor"].toString()),
                            Text('Cdi: ' + list[0]["cdi"].toString()),
                            Text('Cdi Diário: ' +
                                list[0]["cdi_daily"].toString()),
                            Text('Selic: ' + list[0]["selic"].toString()),
                            Text('Selic Diário: ' +
                                list[0]["selic_daily"].toString()),
                          ],
                        )
                      ]),
                );
              }
          }
        });
  }
}
