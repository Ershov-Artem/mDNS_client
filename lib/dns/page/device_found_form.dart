import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../HomePage/widgets/button.dart';
import '../bloc/dns_bloc.dart';
import '../dnsDiscover.dart';

class FoundForm extends StatefulWidget{
  @override
  _FoundFormState createState() => _FoundFormState();
}

class _FoundFormState extends State<FoundForm>{
  late DnsBloc _bloc;

  @override
  void didChangeDependencies(){
    _bloc = BlocProvider.of<DnsBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DnsBloc, DnsState>(
        listener: (context, state) async {},
    builder: (context, state){
          if (state == DnsState.initial()){
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onTap: () async {
                        print('pressed');
                        _bloc.add(const DnsEvent.startSearch());
                      },
                      text: "Поиск",
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),)
                  ],
                )
            );
          } else if (state == DnsState.search()){

                return Container(
                alignment: Alignment.center,
                height: 600,
                width: 350,
                child: ListView.separated(
                itemCount: state.devices.length,
                itemBuilder: (BuildContext context, int index){
                  String key = state.devices.keys.elementAt(index);
              return Container(
                height: 15,
                child: Column(
                  children: [
                    Text("Name: "+key),
                    Text("mac ${state.devices[key]?.mac}"),
                    Text("name ${state.devices[key]?.name}"),
                    Text("ip ${state.devices[key]?.interAddress}"),
                    Text("time ${state.devices[key]?.validUntil}"),
                    Text("protocol ${state.devices[key]?.protocol}"),
                    Text("vendor ${state.devices[key]?.vendor}"),
                    Text("public ${state.devices[key]?.publicKey}"),
                    Text("Basetype ${state.devices[key]?.baseType}"),
                    Text("curve ${state.devices[key]?.curve}"),
                    Text("Firmware ${state.devices[key]?.firmware}"),
                    Text("type ${state.devices[key]?.type}"),
                    Text("pairing ${state.devices[key]?.pairing}")
                  ],
                ),
              );
            },
      separatorBuilder: (BuildContext context, int index)=> const Divider(),
      )
      );
          } else {
            return Center(
              child: Text("Устройства не найдены", style: TextStyle(color: Colors.black) ),
            );
          }
    });
  }
}