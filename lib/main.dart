import 'package:f_converter_2_ext/taxes.dart';
import 'package:flutter/material.dart';
import 'package:f_converter_2_ext/conversao.dart';
import 'package:f_converter_2_ext/bitcoin.dart';
import 'package:f_converter_2_ext/stock.dart';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.amber,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.sync)),
              Tab(icon: Icon(Icons.currency_bitcoin)),
              Tab(icon: Icon(Icons.store)),
              Tab(icon: Icon(Icons.payments)),
            ],
          ),
          title: const Text('Conversor de Moedas'),
        ),
        body: TabBarView(
          children: [Conversao(), Bitcoin(), Stock(), Taxes()],
        ),
      ),
    );
  }
}
