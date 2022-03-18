import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:io';

import 'package:multicast_dns/multicast_dns.dart';

class DnsDiscoveredDevice with EquatableMixin{
  final String mac; // by DomainName
  final String? vendor;
  final int? type;
  final int? baseType;
  final String? name;
  final double? firmware;
  final bool? pairing;
  final int? protocol;
  final String? publicKey;
  final int? curve;
  final int? validUntil;
  final List<InternetAddress>? interAddress;

  const DnsDiscoveredDevice( this.baseType, this.name, this.firmware, this.publicKey, this.curve, this.pairing,
  { required this.mac,
    required this.vendor,
    required this.type,
    required this.protocol,
    required this.validUntil,
    required this.interAddress,
});

  DnsDiscoveredDevice copyWith({
     String? mac,
     String? vendor,
     int? type,
     int? baseType,
     String? name,
     double? firmware,
     bool? pairing,
     int? protocol,
     String? publicKey,
     int? curve,
     int? validUntil,
     List<InternetAddress>? interAddress,
}){
    return DnsDiscoveredDevice(baseType ?? this.baseType,
        name ?? this.name,
        firmware ?? this.firmware,
        publicKey ?? this.publicKey,
        curve ?? this.curve,
        pairing ?? this.pairing,
        mac: mac ?? this.mac,
        vendor: vendor ?? this.vendor,
        type: type ?? this.type,
        protocol: protocol ?? this.protocol,
        validUntil: validUntil ?? this.validUntil,
        interAddress: interAddress ?? this.interAddress,
        );
  }

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
      protocol: paramsMap["protocol"],
      validUntil: null,
      interAddress: null,);
}



//------------------------

class DnsDiscoveryManager{

  static final DnsDiscoveryManager _singleton = DnsDiscoveryManager._internal();

  factory DnsDiscoveryManager() {
    return _singleton;
  }

  DnsDiscoveryManager._internal();

  final String name = '_syncleo._udp.local';

  final MDnsClient _client = MDnsClient();

  //final Timer _timer = Timer.periodic(duration, (timer) { });

  Map<String, DnsDiscoveredDevice> _devices = Map();

  final Map<String, StreamSubscription?> _domainSubscription = Map();

  final Map<String, StreamSubscription?> _txtSubscription = Map();

  final Map<String, StreamSubscription?> _Ipv4Subscription = Map();

  final Map<String, StreamSubscription?> _Ipv6Subscription = Map();

  final Map<String, List<InternetAddress>?> _deviceIA = Map();

  final _deviceController = StreamController<Map<String, DnsDiscoveredDevice>>.broadcast();

  StreamSubscription? _streamDomainSubscription;
  StreamSubscription? _streamTxtSubscription;
  StreamSubscription? _streamIpv4Subscription;
  StreamSubscription? _streamIpv6Subscription;

 // StreamSubscription? _DDDSubscription;

  @override
  Map<String, DnsDiscoveredDevice> get currentDevice =>_devices;

  void _update(Map<String, DnsDiscoveredDevice> devices){
    _devices = devices;
    _deviceController.add(_devices);
  }

  @override
  Stream<Map<String, DnsDiscoveredDevice>> watchChanges(){
    return _deviceController.stream;
  }

  //

  void _deviceTxtFound(String txt, String name, int validUntil){
    bool inMap = false;
    _devices.forEach((key, value) {
      if(key == name){
        _devices.remove(key);
        _devices[key] = fromTxt(txt, name);
        _devices[name]?.copyWith(validUntil: validUntil);
        inMap = true;
      }
    });
    if (inMap == false){
      _devices[name] = fromTxt(txt, name);
      _devices[name]?.copyWith(validUntil: validUntil);
    }
    _update(_devices);
  }

  void _deviceIpFound (InternetAddress ia, String name){
    bool inList = false;
    if (_devices[name]?.interAddress!=null){
      _devices[name]?.interAddress?.forEach((element) {
        if (element == ia){
          inList=true;
        }
      });
    } if (!inList) {
      _devices[name]?.interAddress?.add(ia);
    }
    _update(_devices);
  }

  // void _deviceLost(String txt, String name){
  //   _devices.forEach((key, value) {
  //     if(key == name){
  //       _devices.remove(key);
  //     }
  //   });
  //   _update(_devices);
  // }

  void startScan() async {
    await _client.start();
    if (_domainSubscription[name] == null){
    _streamDomainSubscription = _client.lookup(ResourceRecordQuery.serverPointer(name)).listen((event) {
      if (_Ipv4Subscription[event.name]==null) {
        _streamIpv4Subscription = _client.lookup(
            ResourceRecordQuery.addressIPv4(
                (event as IPAddressResourceRecord).name)).listen((event) {
          _deviceIpFound((event as IPAddressResourceRecord).address, event.name);
        });
        _Ipv4Subscription[event.name] = _streamIpv4Subscription;
      }
      if (_Ipv6Subscription[event.name] == null){
      _streamIpv6Subscription = _client.lookup(ResourceRecordQuery.addressIPv6(event.name)).listen((event) {
        _deviceIpFound((event as IPAddressResourceRecord).address, event.name);
      });
      _Ipv6Subscription[event.name] = _streamIpv6Subscription;
      }
      if (_txtSubscription[(event as PtrResourceRecord).domainName] == null) {
        _streamTxtSubscription = _client.lookup(
            ResourceRecordQuery.text(event.domainName))
            .listen((event) {
          _deviceTxtFound((event as TxtResourceRecord).text,
              (event as PtrResourceRecord).domainName, event.validUntil);
        });
        _txtSubscription[event.domainName] =
            _streamTxtSubscription;
      }
    });
    _domainSubscription[name] = _streamDomainSubscription;
    }
    // addTimer
  }

  void stopScan(){

    _txtSubscription.forEach((key, value) {
      _txtSubscription[key]?.cancel();
    });
    _txtSubscription.clear();

    _domainSubscription.forEach((key, value) {
      _domainSubscription[key]?.cancel();
    });
    _domainSubscription.clear();

    _Ipv4Subscription.forEach((key, value) {
      _Ipv4Subscription[key]?.cancel();
    });
    _Ipv4Subscription.clear();

    _Ipv6Subscription.forEach((key, value) {
      _Ipv6Subscription[key]?.cancel();
    });
    _Ipv6Subscription.clear();
    //stopTimer
    _client.stop();
  }
}