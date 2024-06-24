import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const WaitingRoom());
}

class WaitingRoom extends StatelessWidget {
  const WaitingRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Background App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'SMART WAITING',
            style: TextStyle(
              color: Color.fromRGBO(220, 224, 221, 1),
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(0, 46, 61, 1),
        ),
        body: WaitRoom(),
      ),
    );
  }
}

class WaitRoom extends StatefulWidget {
  @override
  _WaitRoomState createState() => _WaitRoomState();
}

class _WaitRoomState extends State<WaitRoom> {
  final StreamController<DataModel> _streamController = StreamController();

  @override
  void dispose() {
    // stop streaming when app closes
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // A Timer method that runs every 3 seconds
    Timer.periodic(Duration(seconds: 3), (timer) {
      getQueueData();
    });
  }

  Future<void> getQueueData() async {
    var url = Uri.parse('http://192.168.1.16:8080/api/Queue1/300');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final databody = json.decode(response.body);
      DataModel dataModel = DataModel.fromJson(databody);
      _streamController.sink.add(dataModel);
    } else {
      _streamController.sink.addError('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<DataModel>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Please Wait...'));
            } else if (snapshot.hasData) {
              final dataModel = snapshot.data!;
              return SingleChildScrollView(
                child: Container(
                  color: Color.fromRGBO(220, 224, 221, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        margin: EdgeInsets.all(10.0),
                        color: Colors.white60,
                        child: Center(
                          child: Text(
                            'Live Wait Times',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        margin: EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                padding: EdgeInsets.all(8.0),
                                color: Colors.white60,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 0,
                                      child: Text(
                                        'Wait Time:',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 45,
                                      child: Text(
                                        '30:00',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Icon(
                                        Icons.access_time,
                                        size: 36.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                padding: EdgeInsets.all(8.0),
                                color: Colors.white60,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 0,
                                      child: Text(
                                        'Delay:',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 45,
                                      child: Text(
                                        '10:00',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Icon(
                                        Icons.watch_later,
                                        size: 36.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                padding: EdgeInsets.all(8.0),
                                color: Colors.white60,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 0,
                                      child: Text(
                                        'Commute Time:',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 45,
                                      child: Text(
                                        '${dataModel.ticket1Number}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.directions,
                                        size: 36.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(50.0),
                        margin: EdgeInsets.all(10.0),
                        color: Colors.white60,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 36.0,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'Queue Position ${dataModel.queue1Position}',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TicketHomePage(),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}

class TicketHomePage extends StatefulWidget {
  @override
  _TicketHomePageState createState() => _TicketHomePageState();
}

class _TicketHomePageState extends State<TicketHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(220, 224, 221, 1),
      padding: EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Text(
            "YOUR TICKET",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(height: 20),
          TicketWidget(
            width: 350,
            height: 500,
            child: _TicketContent(),
          ),
        ],
      ),
    );
  }
}

class _TicketContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add more widgets if needed
          ],
        ),
        Positioned(
          top: 70,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note_outlined,
                      size: 50,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "SERVICE: RADIO",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "40",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 150,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Date: 2024/5/8 3:37",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Placeholder for TicketWidget
class TicketWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  TicketWidget({
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class DataModel {
  int queue1Position;
  int ticket1Number;

  DataModel({required this.queue1Position, required this.ticket1Number});

  DataModel.fromJson(Map<String, dynamic> json)
      : queue1Position = json['queue1_Position'] ?? 0,
        ticket1Number = json['ticket1_Number'] ?? 0;

  Map<String, dynamic> toJson() => {
        'queue1_Position': queue1Position,
        'ticket1_Number': ticket1Number,
      };
}
