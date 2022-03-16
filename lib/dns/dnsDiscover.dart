import 'package:equatable/equatable.dart';
import 'dart:async';

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

  //validUntil, List<InternetAdress>

  const DnsDiscoveredDevice( this.baseType, this.name, this.firmware, this.publicKey, this.curve, this.pairing,
  { required this.mac,
    required this.vendor,
    required this.type,
    required this.protocol,
});

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

//copyWith

//------------------------

class DnsDiscoveryManager{

  static final DnsDiscoveryManager _singleton = DnsDiscoveryManager._internal();

  factory DnsDiscoveryManager() {
    return _singleton;
  }

  DnsDiscoveryManager._internal();

  final String name = '_syncleo._udp.local';

  final MDnsClient _client = MDnsClient();

  Map<String, DnsDiscoveredDevice> _devices = Map();

  final Map<String, StreamSubscription?> _domainSubscription = Map();

  final Map<String, StreamSubscription?> _txtSubscription = Map();

  final Map<String, StreamSubscription?> _Ipv4Subscription = Map();

  final Map<String, StreamSubscription?> _Ipv6Subscription = Map();

  final _deviceController = StreamController<Map<String, DnsDiscoveredDevice>>.broadcast();

  StreamSubscription? _streamDomainSubscription;
  StreamSubscription? _streamTxtSubscription;
  StreamSubscription? _streamIpv4Subscription;
  StreamSubscription? _streamIpv6Subscription;

  StreamSubscription? _DDDSubscription;

  @override
  Map<String, DnsDiscoveredDevice> get currentDevice =>_devices;

  void _update(Map<String, DnsDiscoveredDevice> devices){
    _devices = devices;
    _deviceController.add(_devices);
  }

  @override
  Stream<Map<String, DnsDiscoveredDevice>> watchChanges(){

    // _DDDSubscription = watchChanges().asBroadcastStream().listen((event) {
    //
    // });
    return _deviceController.stream;
  }

  //

  void _deviceFound(String txt, String name){
    _devices.forEach((key, value) {
      if(key == name){
        _devices[key] = fromTxt(txt, name);
      }
    });
    _update(_devices);
  }

  void _deviceLost(String txt, String name){
    _devices.forEach((key, value) {
      if(key == name){
        _devices.remove(key);
      }
    });
    _update(_devices);
  }

  void startScan() async {
    await _client.start();
    _streamDomainSubscription = _client.lookup(ResourceRecordQuery.serverPointer(name)).listen((event) {

      _streamIpv4Subscription = _client.lookup(ResourceRecordQuery.addressIPv4((event as IPAddressResourceRecord).name)).listen((event) {
        //_deviceFound
      });
      _Ipv4Subscription[event.name] = _streamIpv4Subscription;

      _streamIpv6Subscription = _client.lookup(ResourceRecordQuery.addressIPv6(event.name)).listen((event) {
        //_deviceFound
      });
      _Ipv6Subscription[event.name] = _streamIpv6Subscription;

      _streamTxtSubscription = _client.lookup(ResourceRecordQuery.text((event as PtrResourceRecord).domainName)).listen((event) {
        //_deviceFound
      });
     _txtSubscription[(event as PtrResourceRecord).domainName] = _streamTxtSubscription;

    });
    _domainSubscription[name] = _streamDomainSubscription;
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