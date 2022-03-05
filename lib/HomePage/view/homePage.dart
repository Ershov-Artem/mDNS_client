import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdns_client/HomePage/widgets/deviceFound.dart';

import 'homeForm.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.white,
      body: Container(
        child: BlocProvider<FDBloc>(
          create: (BuildContext context) => FDBloc(FDStatus.initial),
          child: HomeForm(),))
    );
  }
}