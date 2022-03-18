import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdns_client/dns/bloc/dns_bloc.dart';

import 'device_found_form.dart';

class FoundPage extends StatefulWidget{
  @override
  _FoundPageState createState() => _FoundPageState();
}

class _FoundPageState extends State<FoundPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold (
        backgroundColor: Colors.white,
        body:BlocProvider(create: (context) => DnsBloc(),
          child: FoundForm())
    );
  }
}