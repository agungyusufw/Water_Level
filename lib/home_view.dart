import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:water_level/value_model.dart';
import 'package:water_level/card_view.dart';

class HomeView extends StatefulWidget {
  String user;
  String pass;
  String vhost;

  HomeView({this.user, this.pass, this.vhost});
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String userQueue = "homeauto";
  final String passQueue = "homeauto12345!";
  final String vHostQueue = "/Homeauto";
  final String hostQueue = "192.168.4.2";
  final String queues = "Sensor";
  Client client;
  String payload = '';
  bool check_status = false;
  bool water_aktuator = false;
  bool water_sensor = false;
  String aktuator_status = '';
  String sensor_status = '';
  String aktuator_value = '';
  String aktuator_serial = '';
  String sensor_value = '';
  String sensor_serial = '';

  String status_aktuator = 'OFF';
  String status_sensor = 'OFF';

  List<ValueModel> device = [];

  void connect() {
    try {
      ConnectionSettings settings = new ConnectionSettings(
        // host: '192.168.4.2',
        // authProvider: new PlainAuthenticator('homeauto', 'homeauto12345!'),
        // virtualHost: '/Homeauto',
        host: 'rmq2.pptik.id',
        authProvider: new PlainAuthenticator('smkn13bandung', 'qwerty'),
        virtualHost: '/smkn13bandung',
      );
      client = new Client(settings: settings);
      client.connect().then((value) {
        setState(() {
          check_status = true;
          data_aktuator();
          data_sensor();
        });
      });
    } catch (e) {
      print("kesalahan 344or $e");
    }
  }

  void data_aktuator() {
    client
        .channel()
        .then((Channel channel) => channel.queue("Water Aktuator", durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
              print("test ${message.payloadAsString}");
              setValueAktuator(message.payloadAsString);
              setState(() {
                payload = message.payloadAsString;
              });
            }));
  }

  void data_sensor() {
    client
        .channel()
        .then((Channel channel) => channel.queue("Water Sensor", durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
              print("test ${message.payloadAsString}");
              setValueSensor(message.payloadAsString);
              setState(() {
                payload = message.payloadAsString;
              });
            }));
  }

  void setValueAktuator(String message) {
    List<String> a = message.split("#");
    int cek = int.parse(a[1]);
    setState(() {
      aktuator_value = a[1];
      aktuator_serial = '3505dedf-d7a7-4b1c-b662-b3d141693555';
      if (cek == 0) {
        aktuator_status = 'OFF';
      } else if (cek == 1) {
        aktuator_status = 'ON';
      }
      device.add(ValueModel(aktuator_serial, "Aktuator", aktuator_value, aktuator_status));
    });
  }

  void setValueSensor(String message) {
    List<String> a = message.split("#");
    int cek = int.parse(a[1]);
    setState(() {
      aktuator_value = a[1];
      aktuator_serial = '2bf0c806-eebb-467c-9a47-cff1ded5263c';
      if (cek == 00) {
        aktuator_status = 'Kosong';
      } else if (cek == 11) {
        aktuator_status = 'Penuh';
      }
      device.add(ValueModel(aktuator_serial, "Sensor", aktuator_value, aktuator_status));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: check_status?ListView.builder(
                  reverse: false,
                  addAutomaticKeepAlives: true,
                  itemCount: device.length,
                  itemBuilder: (context,idx){
                    return ContentCardView(device: device[idx],);
                  },
                ):Container(
                  child: Center(
                    child: Text("RMQ Not Connected \n Please check your credential"),
                  ),
                )
            )
        )
    );
  }
}



