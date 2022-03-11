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

  factory DnsDiscoveredDevice.fromJwt(String token) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return ;
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

class DnsDiscoveryManager{

  static final DnsDiscoveryManager _singleton = DnsDiscoveryManager._internal();

  factory DnsDiscoveryManager() {
    return _singleton;
  }

  DnsDiscoveryManager._internal();

  final MDnsClient _client = MDnsClient();
  DnsDiscoveredDevice? _config;
  final configController = StreamController<DnsDiscoveredDevice?>.broadcast();

  @override
  DnsDiscoveredDevice? get currentConfig => _config;

  void _updateCinfig(DnsDiscoveredDevice? config){
    _config = config;
    configController.add(_config);
  }

  @override
  Stream<DnsDiscoveredDevice?> watchAccountChanges() {
    _refreshConfig();
    return configController.stream;
  }

  Future _refreshConfig() async {
    final client = _client;
    if (client == null){
      _updateCinfig(null);
      return;
    }
  }
}