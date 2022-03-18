import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../dnsDiscover.dart';

part 'dns_state.dart';
part 'dns_event.dart';

class DnsBloc extends Bloc<DnsEvent, DnsState>{
  StreamSubscription? streamSubscription;
  DnsBloc() : super(DnsState.initial()){
    on<DnsEvent>((event, emit)  {
      DnsDiscoveryManager manager = DnsDiscoveryManager();

       event.map(
        startSearch: (e) {
          manager.startScan();
          emit(state.copyWith(isSearching: true));
          streamSubscription = manager.watchChanges().listen((event) {
            event.forEach((key, value) {
              add(DnsEvent.uplDevices(event[value], key));
            });
          });
        },
        uplDevices: (e) {
            emit(state.copyWith(devices: ([e.name, e.device]as Map<String, DnsDiscoveredDevice>)));
        },
         // delDevices: (e){
         //
         // },
         stopSearch: (e){
           manager.stopScan();
           emit(state.copyWith(isSearching: false));
         }
      );
    }
    );

  }
}
