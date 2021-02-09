import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';

class Config {
  factory Config() {
    return _config;
  }

  Config._internal();

  static final Config _config = Config._internal();

  String baseUrl = "http://sahary.agentsmanage.com/api/";
  String imageUrl = "http://sahary.agentsmanage.com/image/";
  int agentId;
  bool looded = false;
  final TextEditingController locationController = TextEditingController();
  Address first;
  Coordinates coordinates;
  List<Address> addresses;
  String verchilId;
  double lat = 0.0;
  double long = 0.0;
  String token = "";
  String companyName;
  double tax;
  String trn;
  String address;
  String mobileNo;
  String telephoneNo;
  String logo;
  bool dontloadCustomers = false;
  bool dontloadItems = false;
  int editPrice;
  bool qrCodeScan;
}

final Config config = Config();
