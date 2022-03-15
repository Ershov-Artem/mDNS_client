import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async';

import 'package:multicast_dns/multicast_dns.dart';

class DnsDiscoveredDevice with EquatableMixin{
  final String mac;
  final String vendor;
  final int type;
  final int baseType;
  final String name;
  final double firmware;
  final bool pairing;
  final int protocol;
  final String publicKey;
  final int curve;

  const DnsDiscoveredDevice( this.baseType, this.name, this.firmware, this.publicKey, this.curve, this.pairing,
  { required this.mac,
    required this.vendor,
    required this.type,
    required this.protocol,
});

  // DnsDiscoveredDevice.fromTxt(String deviceTxt){
  //   Map<String, dynamic> paramsMap = Map();
  //   List<String> params = [];
  //   params = deviceTxt.split("\n");
  //   for (String par in params){
  //       paramsMap.addAll((par.split("=") as Map<String, dynamic>));
  //   }
  //   return DnsDiscoveredDevice(baseType, name, firmware, publicKey, curve, pairing, mac: mac, vendor: vendor, type: type, protocol: protocol);
  // }

  @override
  List<Object?> get props => [
  mac,
  vendor,
  type,
  baseType,
  name,
  firmware,
  pairing,
  protocol,
  publicKey,
  curve,
  ];

  @override
  bool? get stringify => true;
}

DnsDiscoveredDevice fromTxt(String deviceTxt, String name){
  Map<String, dynamic> paramsMap = Map();
  List<String> params = [];
  params = deviceTxt.split("\n");
  for (String par in params){
    paramsMap.addAll((par.split("=") as Map<String, dynamic>));
  }
  return DnsDiscoveredDevice(paramsMap["basetype"],
      name, paramsMap["firmware"],
      paramsMap["public"],
      paramsMap["curve"],
      paramsMap["pairing"],
      mac: paramsMap["macaddr"],
      vendor: paramsMap["vendor"],
      type: paramsMap["devtype"],
      protocol: paramsMap["protocol"]);
}

//------------------------

class DnsDiscoveryManager{

  static final DnsDiscoveryManager _singleton = DnsDiscoveryManager._internal();

  factory DnsDiscoveryManager() {
    return _singleton;
  }

  DnsDiscoveryManager._internal();

  List<DnsDiscoveredDevice> _devices = [];
  final deviceController = StreamController<List<DnsDiscoveredDevice>>.broadcast();

  @override
  List<DnsDiscoveredDevice> get currentDevice =>_devices;

  void update(List<DnsDiscoveredDevice> devices){
    _devices = devices;
    deviceController.add(_devices);
  }

  @override
  Stream<List<DnsDiscoveredDevice>> watchChanges(){
    return deviceController.stream;
  }

  void deviceFound(List<DnsDiscoveredDevice> devices, String txt, String name){
    devices.add(fromTxt(txt, name));
  }

  void deviceNotFound(){}
}