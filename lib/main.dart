import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:llo/Service1Page.dart'; // Import Service1Page.dart
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 46, 61, 1),
      body: Center(
        child: Text(
          'SMART WAITING',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(220, 224, 221, 1)),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SMART WAITING',
          style: TextStyle(
            color: Color.fromRGBO(220, 224, 221, 1),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 46, 61, 1),
      ),
      backgroundColor: Color.fromRGBO(220, 224, 221, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Économisez votre temps, profitez de chaque instant',
            style: TextStyle(
              color: Color.fromRGBO(0, 46, 61, 1),
              fontSize: 21,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height: 70), // Add some space between the text and the button
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationPage()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 46, 61, 1),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 4,
                foregroundColor: Color.fromRGBO(
                    220, 224, 221, 1) // Set the text color to white
                ),
            child: Text(
              'Réserver un Ticket',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  //int? ticketNumber;
  //DateTime creationDate = DateTime.now();
  //int? service;

  /*Future<void> fetchTicketInfo() async {
    try {
      var response = await http
          .get(Uri.parse('http://192.168.2.165:8080/api/Queue1/ticket-info'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          if (data['ticketNumber'] != null) {
            ticketNumber = data['ticketNumber'];
          }

          if (data['service'] != null) {
            service = data['service'];
          } else {
            service = 0;
          }

          if (data['CreationDate'] != null) {
            creationDate = DateTime.fromMillisecondsSinceEpoch(
                data['CreationDate'] * 1000);
          }

          print(ticketNumber);
          print(creationDate);
          print(service);
          print(data);
        });
      } else {
        throw Exception('Failed to load ticket info');
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/
  double lat = 0;
  double lon = 0;
  double lat2 = 34.7706937;
  double lon2 = 10.7606712;
  //double lat1 = double.parse(lat);
  // double lon1 = double.parse(lon);
  //double lat2 = double.parse(lath);
  // double lon2 = double.parse(lonh);

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //   // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //     // Location services are not enabled don't continue
      //     // accessing the position and request users of the
      //     // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //       // Permissions are denied, next time you could try
        //       // requesting permissions again (this is also where
        //       // Android's shouldShowRequestPermissionRationale
        //       // returned true. According to Android guidelines
        //       // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //   // When we reach here, permissions are granted and we cang
    //   // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  double distanceInMeters =
      Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
  String? uniqueID;
  Future<String?> generateUniqueID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String deviceAttributes = androidInfo.model +
          androidInfo.manufacturer +
          androidInfo.product +
          androidInfo.version.sdkInt.toString();
      uniqueID = deviceAttributes.hashCode.toString();
      return uniqueID;
    } catch (e) {
      print("Error getting device info: $e");
    }
  }

  Future<dynamic> getUserByUUID(String uuid) async {
    final response =
        await http.get(Uri.parse('http://192.168.1.16:8080/api/Users/$uuid'));

    if (response.statusCode == 200) {
      // If the server returns a successful response, parse the JSON
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      // If the server returns a 404 Not Found response, handle it accordingly
      print("user not found");
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load user');
    }
  }

  Future<void> postUser() async {
    final body = {
      "userId": 0,
      "uuid": uniqueID,
    };

    const url = 'http://192.168.1.16:8080/api/Users/id';
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      print(response);
      if (response.statusCode == 201) {
        print('User posted successfully!');
      } else {
        print('Failed to post user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  /*@override
  Future<void> initState() async {
    super.initState();
    await generateUniqueID();
    print(uniqueID);
    if (uniqueID != null) {
      getUserByUUID(uniqueID!).then((response) {
        if (response == null) {
          postUser();
          print("user created success");
        } else {
          print('User is already created');
        }
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Réservation',
          style: TextStyle(
            color: Color.fromRGBO(220, 224, 221, 1),
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 46, 61, 1),
      ),
      backgroundColor: Color.fromRGBO(220, 224, 221, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                //fetchTicketInfo();
                await ticketinfo1();
                //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => WaitingRoom()),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 46, 61, 1),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 4,
              ),
              child: Text(
                ' Radiologie ',
                style: TextStyle(
                  color: Color.fromRGBO(220, 224, 221, 1),
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                //postUser();
                await ticketinfo2();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 46, 61, 1),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 4,
              ),
              child: Text(
                '  Medecin  ',
                style: TextStyle(
                  color: Color.fromRGBO(220, 224, 221, 1),
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                //generateUniqueID();
                await ticketinfo3();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 46, 61, 1),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 4,
              ),
              child: Text(
                'Laboratoire',
                style: TextStyle(
                  color: Color.fromRGBO(220, 224, 221, 1),
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await generateUniqueID();
                print(uniqueID);
                if (uniqueID != null) {
                  await getUserByUUID(uniqueID!).then((response) async {
                    if (response == null) {
                      await postUser();
                      print("user created success");
                    } else {
                      print('User is already created');
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 46, 61, 1),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 4,
              ),
              child: Text(
                'Service 4',
                style: TextStyle(
                  color: Color.fromRGBO(220, 224, 221, 1),
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _determinePosition().then((value) {
                  lat = double.parse('${value.latitude}');
                  lon = double.parse('${value.longitude}');
                });
                print(lon);
                print(lat);
                double distanceInMeters =
                    Geolocator.distanceBetween(lat, lon, lat2, lon2);
                print(distanceInMeters / 1000);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 46, 61, 1),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                elevation: 4,
              ),
              child: Text(
                'Service 5',
                style: TextStyle(
                  color: Color.fromRGBO(220, 224, 221, 1),
                  fontSize: 24,
                ),
              ),
            ),
            /* SizedBox(height: 16),
            Text('Ticket Number: $ticketNumber'),
            Text(
                'Creation Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(creationDate)}'),
            Text('Service: $service'),*/
          ],
        ),
      ),
    );
  }

  int? ticketNumber;
  String? service;
  int? queueId;
  int? position;
  int? userId;
  int? waitingRoomId;
  String? creationDate;
  bool isLoading = false;

  Future<Map<String, dynamic>?> reserverticket1() async {
    const url = 'http://192.168.1.16:8080/api/Queue1/service1';
    final body = {
      "queue1_id": 0,
      "queue1_Position": 0,
      "ticket1_Number": 0,
      "userId": 5,
      "waiting_room_id1": 0,
      "waiting_room_id": {"waiting_room_id": 0},
      "service_Id": 1,
      "creation_Date": "2024-05-07T06:27:26.087Z"
    };
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Ticket reserved successfully!');
        return responseData;
      } else {
        print('Failed to reserve ticket. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<void> ticketinfo1() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic>? response = await reserverticket1();
    if (response != null) {
      queueId = response['queue1_id'];
      position = response['queue1_Position'];
      ticketNumber = response['ticketNumber'];
      userId = response['userid'];
      waitingRoomId = response['waiting_room_id'];
      service = 'radio';
      creationDate = response['creationDate'];
      print(response);
      print('Queue ID: $queueId');
      print('Position: $position');
      print('Ticket Number: $ticketNumber');
      print('User ID: $userId');
      print('Waiting Room ID: $waitingRoomId');
      print('Service ID: $service');
      print('Creation Date: $creationDate');
    }

    setState(() {
      isLoading = false;
    });
    setState(() {
      isLoading = false;
    });

    if (response != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Service1Page(
                  ticketNumber: ticketNumber,
                  queueId: queueId,
                  creationDate: creationDate,
                  service: service,
                )),
      );
    } else {
      // Handle the case where the API request failed
      print('Failed to fetch ticket info');
    }
  }

  int? ticketNumber2;
  String? service2;
  int? queueId2;
  int? position2;
  int? userId2;
  int? waitingRoomId2;
  String? creationDate2;
  bool isLoading2 = false;
  Future<Map<String, dynamic>?> reserverticket2() async {
    const url = 'http://192.168.1.16:8080/api/Queue1/service2';
    final body = {
      "queue1_id": 0,
      "queue1_Position": 0,
      "ticket1_Number": 0,
      "userId": 5,
      "waiting_room_id1": 0,
      "waiting_room_id": {"waiting_room_id": 0},
      "service_Id": 2,
      "creation_Date": "2024-05-07T06:27:26.087Z"
    };
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Ticket reserved successfully!');
        return responseData;
      } else {
        print('Failed to reserve ticket. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<void> ticketinfo2() async {
    setState(() {
      isLoading2 = true;
    });

    Map<String, dynamic>? response2 = await reserverticket2();
    if (response2 != null) {
      queueId2 = response2['queue1_id'];
      position2 = response2['queue1_Position'];
      ticketNumber2 = response2['ticketNumber'];
      userId2 = response2['userid'];
      waitingRoomId2 = response2['waiting_room_id'];
      service2 = 'Medecin';
      creationDate2 = response2['creationDate'];
      print(response2);
      print('Queue ID: $queueId2');
      print('Position: $position2');
      print('Ticket Number: $ticketNumber2');
      print('User ID: $userId2');
      print('Waiting Room ID: $waitingRoomId2');
      print('Service ID: $service2');
      print('Creation Date: $creationDate2');
    }

    setState(() {
      isLoading2 = false;
    });

    if (response2 != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Service1Page(
                  ticketNumber: ticketNumber2,
                  queueId: queueId2,
                  creationDate: creationDate2,
                  service: service2,
                )),
      );
    } else {
      // Handle the case where the API request failed
      print('Failed to fetch ticket info');
    }
  }

  int? ticketNumber3;
  String? service3;
  int? queueId3;
  int? position3;
  int? userId3;
  int? waitingRoomId3;
  String? creationDate3;
  bool isLoading3 = false;

  Future<Map<String, dynamic>?> reserverticket3() async {
    const url = 'http://192.168.1.16:8080/api/Queue1/service3';
    final body = {
      "queue1_id": 0,
      "queue1_Position": 0,
      "ticket1_Number": 0,
      "userId": 5,
      "waiting_room_id1": 0,
      "waiting_room_id": {"waiting_room_id": 0},
      "service_Id": 3,
      "creation_Date": "2024-05-07T06:27:26.087Z"
    };
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Ticket reserved successfully!');
        return responseData;
      } else {
        print('Failed to reserve ticket. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<void> ticketinfo3() async {
    setState(() {
      isLoading3 = true;
    });

    Map<String, dynamic>? response3 = await reserverticket3();
    if (response3 != null) {
      queueId3 = response3['queue1_id'];
      position3 = response3['queue1_Position'];
      ticketNumber3 = response3['ticketNumber'];
      userId3 = response3['userid'];
      waitingRoomId3 = response3['waiting_room_id'];
      service3 = 'Labo';
      creationDate3 = response3['creationDate'];
      print(response3);
      print('Queue ID: $queueId3');
      print('Position: $position3');
      print('Ticket Number: $ticketNumber3');
      print('User ID: $userId3');
      print('Waiting Room ID: $waitingRoomId3');
      print('Service ID: $service3');
      print('Creation Date: $creationDate3');
    }

    setState(() {
      isLoading3 = false;
    });

    if (response3 != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Service1Page(
                  ticketNumber: ticketNumber3,
                  queueId: queueId3,
                  creationDate: creationDate3,
                  service: service3,
                )),
      );
    } else {
      // Handle the case where the API request failed
      print('Failed to fetch ticket info');
    }
  }
}
