import 'package:appshop/providers/counter_provider.dart';
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo contador"),
      ),
      body: Column(
        children: [
          Text(provider?.state.value.toString() ?? "0"),
          IconButton(
            onPressed: () {
              setState(() {
                provider?.state.inc();
              });
              print(provider?.state.value.toString());
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                provider?.state.dec();
              });
              print(provider?.state.value.toString());
            },
            icon: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
