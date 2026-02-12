import 'dart:convert';

class Users{
  // late final name;
  final email;
  final nat;
  final phone ;
  final cell;

Users({
    required this.email,
    required this.nat,
    required this.cell,
    required this.phone,
  });

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
    email: json['email'],
    nat: json['nat'],
    cell: json['cell'],
    phone: json['phone']
  );
  }
}
