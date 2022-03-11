import 'package:multicast_dns/multicast_dns.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<List<String>> foundDevice() async{
  List<String> devices = [];
  const String name = '_syncleo._udp.local';
  final MDnsClient client = MDnsClient();
  await client.start();
  client.lookup(ResourceRecordQuery.serverPointer(name)).listen((event) {
    print("ptr:"+event.toString());
    client.lookup(ResourceRecordQuery.text((event as PtrResourceRecord).domainName)).listen((event) {
      print("txt:"+event.toString());
    });
  });

  // await for (final PtrResourceRecord ptr in client
  //     .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))){
  //   await for (final SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
  //       ResourceRecordQuery.service(ptr.domainName))){
  //       final String bundleId = "";
  //       print('${srv.target}:${srv.port} for $bundleId.');
  //       devices.add("${srv.target}:${srv.port} ");
  //     }
  //   }
  //client.stop();
  return devices;
}

class FDBloc extends Cubit<FDStatus>{
  FDBloc(state) : super(state);
  foundDevices() async{
    List<String> devices = [];
    emit(FDStatus.loading);
    print('loading');
    devices = await foundDevice();
    if (devices != []){
      emit(FDStatus.fnd);
      print('fnd');
    } else {
      emit(FDStatus.nf);
      print('nf');
    }
    return devices;
  }
}

enum FDStatus {loading, fnd, nf, initial}