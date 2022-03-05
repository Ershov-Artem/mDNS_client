import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mdns_client/HomePage/widgets/button.dart';
import 'package:mdns_client/HomePage/widgets/deviceFound.dart';

class HomeForm extends StatefulWidget{
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm>{
  late FDBloc _bloc;
  List<String> _list = [];

  @override
  void didChangeDependencies(){
    _bloc = BlocProvider.of<FDBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
    bloc: _bloc,
    listener: (context, state) async {},
    builder: (context, state) {
      if (state == FDStatus.initial){
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                onTap: () async {
                  print('pressed');
                _list = await _bloc.foundDevices();
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
      } else if (state == FDStatus.loading){
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Color(0xFF8ebbff),
              ),
              Text("Поиск устройств", style: TextStyle(color: Colors.black)),
            ],
          )
        );
      } else if (state == FDStatus.fnd){
        return Container(
          alignment: Alignment.center,
            height: 600,
            width: 350,
            child: ListView.separated(
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  height: 15,
                  child: Text(_list[index], style: TextStyle(color: Colors.black),),
                );
              },
              separatorBuilder: (BuildContext context, int index)=> const Divider(),
            )
        );
      } else {
          return Center(
          child: Text("Устройства не найдены", style: TextStyle(color: Colors.black) ),
          );
      }}
  );
}