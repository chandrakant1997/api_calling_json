import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('JSON ListView with Multiple Text Items')),
        body: JsonListView(),
      ),
    );
  }
}

class Studentdata {
  int studentID;
  String studentName;
  int studentPhoneNumber;
  String studentSubject;

  Studentdata(
      {this.studentID,
      this.studentName,
      this.studentPhoneNumber,
      this.studentSubject});

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
        studentID: json['id'],
        studentName: json['student_name'],
        studentPhoneNumber: json['student_phone_number'],
        studentSubject: json['student_class']);
  }
}

class JsonListView extends StatefulWidget {
  JsonListViewWidget createState() => JsonListViewWidget();
}

class JsonListViewWidget extends State {
  final String apiURL =
      'https://flutter-examples.000webhostapp.com/getStudentInfo.php';

  Future<List<Studentdata>> fetchStudents() async {
    var response = await http.get(apiURL);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Studentdata> studentList = items.map<Studentdata>((json) {
        return Studentdata.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  selectedItem(BuildContext context, String dataHolder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(dataHolder),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Studentdata>>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data
              .map((data) => Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          selectedItem(context, data.studentName);
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text(
                                      'ID = ' + data.studentID.toString(),
                                      style: TextStyle(fontSize: 21))),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text('Name = ' + data.studentName,
                                      style: TextStyle(fontSize: 21))),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text(
                                      'Phone Number = ' +
                                          data.studentPhoneNumber.toString(),
                                      style: TextStyle(fontSize: 21))),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text(
                                      'Subject = ' + data.studentSubject,
                                      style: TextStyle(fontSize: 21))),
                            ]),
                      ),
                      Divider(color: Colors.black),
                    ],
                  ))
              .toList(),
        );
      },
    );
  }
}
