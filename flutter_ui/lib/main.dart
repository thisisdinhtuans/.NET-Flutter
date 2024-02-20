import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ui/person.dart';
import 'package:flutter_ui/person_screen.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Person List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<void> _initPersonData;
  List<Person> lstPerson = [];
  @override
  void initState() {
    super.initState();
    _initPersonData = _initGetAllPersons();
  }

  Future<void> _initGetAllPersons() async {
    try {
      var url = Uri.https('10.0.2.2:7185', '/api/Person/read');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        lstPerson = jsonResponse.map((e) => Person.fromJson(e)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<bool> deletePerson(int id) async {
    bool isSuccess = false;
    var client = http.Client();
    try {
      var url = Uri.https('10.0.2.2:7185', '/api/Person/delete');
      var headers = {'Content-Type': 'application/json'};
      var body = convert.jsonEncode({
        'id': id,
      });

      var response = await client.delete(url, headers: headers, body: body);

      if (response.statusCode == 204) {
        isSuccess = true;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      client.close();
    }
    return isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Person List"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder(
          future: _initPersonData,
          builder: (BuildContext context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                {
                  return const Center(
                    child: CircularProgressIndicator(),
                    // child: Text('Loading ...'),
                  );
                }
              case ConnectionState.done:
                return ListView.builder(
                  itemCount: lstPerson.length,
                  itemBuilder: (context, index) {
                    return Card(
                      key: ValueKey(lstPerson[index].id),
                      shadowColor: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                              "${lstPerson[index].firstname}-${lstPerson[index].lastname}"),
                          subtitle: Text(
                              "${lstPerson[index].phone} ${lstPerson[index].address}"),
                          trailing: Expanded(
                            child: SizedBox(
                              width: 60,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.purple,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PersonScreen(),
                                                  settings: RouteSettings(
                                                      name: "editPerson",
                                                      arguments: convert
                                                          .jsonEncode(lstPerson[
                                                              index]))));
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Are you sure, do you want to delete?"),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      var isDeleted =
                                                          await deletePerson(
                                                              lstPerson[index]
                                                                  .id);
                                                      if (isDeleted) {
                                                        //remove card items from the list
                                                        lstPerson
                                                            .removeAt(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Removed Successfully"),
                                                          backgroundColor:
                                                              Colors.green,
                                                          duration: Duration(
                                                              seconds: 5),
                                                        ));
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MyHomePage()),
                                                        );
                                                      }
                                                    },
                                                    child: const Text("Yes"),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    )),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("No"),
                                                ),
                                              ],
                                            );
                                          }),
                                        );
                                      },
                                      child:
                                          Icon(Icons.delete, color: Colors.red),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PersonScreen()));
        },
        tooltip: 'Add new person',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
