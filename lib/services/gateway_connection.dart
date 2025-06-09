import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class GatewayConnection {
  static final GatewayConnection _gatewayConnection =
      GatewayConnection._internal();
  GatewayConnection._internal();
  factory GatewayConnection() => _gatewayConnection;

  MqttBrowserClient? client;
  String server = 'ws://localhost';
  String clientId = 'flutter_${DateTime.now().millisecondsSinceEpoch}';

  Future<void> connect() async {
    client = MqttBrowserClient(server, clientId);
    client!.port = 8080;
    client!.onDisconnected = onDisconnected;
    client!.logging(on: true);

    try {
      await client!.connect();
    } catch (e) {
      print('Exception: $e');
      client!.disconnect();
    }

    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('Conectado ao broker MQTT');
    } else {
      print('Falha na conexão');
    }
  }

  void disconnect() {
    client!.disconnect();
  }

  void onDisconnected() {
    print('Desconectado do broker');
  }
}
