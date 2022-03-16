import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../dnsDiscover.dart';

part 'dns_state.dart';
part 'dns_event.dart';

class DnsBloc extends Bloc<DnsEvent, DnsState>{
  DnsBloc() : super(DnsState.initial()){
    on<DnsEvent>((event, emit)  {
       event.map(
        startSearch: (e) {

        },
        uplDevices: (e) {

        },
         delDevices: (e){

         },
         stopSearch: (e){
         }
      );
    });
  }
}
