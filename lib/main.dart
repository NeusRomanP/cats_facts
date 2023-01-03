import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<String>? _fact;

  Future<String> getFact() async {

    final response = await http.get(Uri.https("catfact.ninja", "/fact"));

    if (response.statusCode == 200) {
      String body = response.body;
      final jsonData = jsonDecode(body);
      return jsonData["fact"];
    }else{
      return "Something went wrong! :(";
    }
  }

  @override
  void initState(){
    super.initState();
    _fact = getFact();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cats facts',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Cats facts"),
        ),
        body: FutureBuilder(
          future: _fact,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              print(snapshot.data);
              return Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Container(
                    child: Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 24
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }else if(snapshot.hasError){
              return Text("Error");
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}

