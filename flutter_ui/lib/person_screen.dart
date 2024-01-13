import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ui/main.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final TextEditingController _firstNameCtlr = TextEditingController();
  final TextEditingController _lastNameCtlr = TextEditingController();
  final TextEditingController _phoneCtlr = TextEditingController();
  final TextEditingController _addressCtlr = TextEditingController();

  // Future<bool> savePerson(
  //     String firstName, String lastName, String phone, String address) async {
  //   bool isSuccess = false;
  //   var client = http.Client();
  //   try {
  //     var response = await client
  //         .post(Uri.https('10.0.2.2:7185', '/api/Person/create'), body: {
  //       'firstname': firstName,
  //       'lastname': lastName,
  //       'phone': phone,
  //       'address': address
  //     });

  //     if (response.statusCode == 200) {
  //       isSuccess = true;
  //     } else {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //   } finally {
  //     client.close();
  //   }
  //   return isSuccess;
  // }

  Future<bool> addPerson(
      String firstName, String lastName, String phone, String address) async {
    bool isSuccess = false;
    var client = http.Client();
    try {
      var url = Uri.https('10.0.2.2:7185', '/api/Person/create');
      var headers = {'Content-Type': 'application/json'};
      var body = convert.jsonEncode({
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'address': address,
      });

      var response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
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

  resetInputFields() {
    _firstNameCtlr.clear();
    _lastNameCtlr.clear();
    _phoneCtlr.clear();
    _addressCtlr.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _firstNameCtlr.dispose();
    _lastNameCtlr.dispose();
    _phoneCtlr.dispose();
    _addressCtlr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Person')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text("Test"),
                TextFormField(
                  controller: _firstNameCtlr,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "First Name"),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _lastNameCtlr,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Last Name"),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _phoneCtlr,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Phone"),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _addressCtlr,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Address"),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      var firstName = _firstNameCtlr.text;
                      var lastName = _lastNameCtlr.text;
                      var phone = _phoneCtlr.text;
                      var address = _addressCtlr.text;
                      if (firstName.isNotEmpty &&
                          lastName.isNotEmpty &&
                          phone.isNotEmpty &&
                          address.isNotEmpty) {
                        bool isSaved = await addPerson(
                            firstName, lastName, phone, address);
                        if (isSaved) {
                          resetInputFields();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Successfully create'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 5),
                          ));
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const MyHomePage();
                          }), (r) {
                            return false;
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Error while saving data'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 5),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please fill all the fields'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 5),
                        ));
                      }
                    })
              ],
            ),
          ),
        ));
  }
}
