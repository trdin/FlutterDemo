import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Person.dart';

Future<Person> createPerson(String name) async {
  final http.Response response = await http.post(
    Uri.parse('http://192.168.0.21:3001/api/v1/person'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
    }),
  );

  if (response.statusCode == 200) {
    print(response.body);
    return Person.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create person.');
  }
}

class InputApp extends StatelessWidget {
  const InputApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Write a name'),
          backgroundColor: Colors.pink,
        ),
        body: const NamesApp());
  }
}

class NamesApp extends StatefulWidget {
  const NamesApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NamesAppState createState() {
    return _NamesAppState();
  }
}

class _NamesAppState extends State<NamesApp> {
  final TextEditingController _controller = TextEditingController();
  Future<Person> _futurePerson = null as Future<Person>;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creating Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        // ignore: unnecessary_null_comparison
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Enter Title'),
                ),
                ElevatedButton(
                  child: const Text('Create Data'),
                  onPressed: () {
                    setState(() {
                      _futurePerson = createPerson(_controller.text);
                    });
                  },
                ),
              ],
            ),
            (_futurePerson != null)
                ? FutureBuilder<Person>(
                    future: _futurePerson,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data!.name);
                        return Text(snapshot.data!.name);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                : const Text("no data yet"),
          ],
        ),
      ),
    );
  }
}
