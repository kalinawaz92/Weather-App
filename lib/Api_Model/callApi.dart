import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/Api_Model/users_api_model.dart';

import 'users_api_model.dart';

class callApi extends StatefulWidget {
  const callApi({super.key});

  @override
  State<callApi> createState() => _callApiState();
}

class _callApiState extends State<callApi> {

  List<dynamic> usersList = [];


  Future<void> fetchUsers() async{
    final url = "https://randomuser.me/api/?results=5";
    final uri = Uri.parse(url);
    try{
      final response = await http.get(uri);
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        usersList = data['results'];
        setState(() {
          // results = Weather.fromJson(data);
          usersList = usersList.map((json)=> Users.fromJson(json)).toList();
        });
      } else {
          // throw Exception("Failed to load Users!");
        print("Failed to load data!");
      }
    } catch (e){
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Widget build(BuildContext context) {
    return Scaffold(
    body: RefreshIndicator(
      onRefresh: fetchUsers,
      child: ListView.builder(
        itemCount: usersList.length,
          itemBuilder: (context, index) {
            final users = usersList[index];
          return Container(
            height: 150,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFE7F0F1),
            ),
            child: Column(
              children: [
                Text(users.phone)
              ],
            ),
          );
          },
      ),
    ),
    );
  }
}
