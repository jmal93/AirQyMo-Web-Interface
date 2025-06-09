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
    client!.onDisconnected = _onDisconnected;
    client!.onSubscribed = _onSubscribed;
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

  Future<void> subscribe(String topic) async {
    try {
      client!.subscribe(topic, MqttQos.atMostOnce);
      client!.updates!.listen(_onMessage);
    } catch (e) {
      print('Erro na inscrição: $e');
    }
  }

  void _onSubscribed(String topic) {
    print('Se inscreveu no tópico $topic');
  }

  void disconnect() {
    client!.disconnect();
  }

  void _onDisconnected() {
    print('Desconectado do broker');
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(
      recMess.payload.message,
    );
    print('mensagem recebida: $message');
  }
}
