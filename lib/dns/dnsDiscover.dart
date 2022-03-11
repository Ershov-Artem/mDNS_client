import 'package:multicast_dns/multicast_dns.dart';

class DnsDiscoveredDevice {
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

  DnsDiscoveredDevice( this.baseType, this.name, this.firmware, this.publicKey, this.curve, this.pairing,
  { required this.mac,
    required this.vendor,
    required this.type,
    required this.protocol,
});
}

class DnsDiscoveryManager{

  static final DnsDiscoveryManager _singleton = DnsDiscoveryManager._internal();

  factory DnsDiscoveryManager() {
    return _singleton;
  }

  DnsDiscoveryManager._internal();

  Stream updateConfig(List<String> vendors){
    const String name = '_syncleo._udp.local';
    MDnsClient client = MDnsClient();


    client.lookup(ResourceRecordQuery.serverPointer(name)).listen((event) {
      client.lookup(ResourceRecordQuery.text((event as PtrResourceRecord).domainName)).listen((event) {
        for (String vendor in vendors){
          if((event as TxtResourceRecord).text.contains(vendor)){

          }
        }
      });
    });
  }

  Stream<ResourceRecord> beginScan(String name){
    MDnsClient client = MDnsClient();
    client.start();
    return client.lookup(ResourceRecordQuery.serverPointer(name));
  }

}