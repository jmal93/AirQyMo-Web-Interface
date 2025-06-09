import 'package:airqymo/services/gateway_connection.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  HomePageView({super.key});

  final mqttManager = GatewayConnection();
  void connect() async {
    await mqttManager.connect();
    mqttManager.subscribe('dados/saude');
  }

  @override
  Widget build(BuildContext context) {
    connect();
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Home Page"))),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text("Tempo real"),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text("Histórico"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
