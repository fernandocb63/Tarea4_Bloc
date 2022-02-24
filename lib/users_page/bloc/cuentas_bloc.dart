import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'cuentas_event.dart';
part 'cuentas_state.dart';

class CuentasBloc extends Bloc<CuentasEvent, CuentasState> {
  CuentasBloc() : super(CuentasInitial()) {
    on<CuentasEvent>(CuentasCambiar);
  }

  void CuentasCambiar(CuentasEvent event, Emitter emitter) async{
    var MapaCuenta = await _getLista();
    if (MapaCuenta == null){
      emitter(CuentasErrorState(errorMsg: "Error"));
    } else {
      emitter(CuentaSelected(cuentamap: MapaCuenta));
    }
  }

  Future _getLista() async {
    try {
      http.Response res = await http.get(Uri.parse("https://api.sheety.co/d89b0f60f5a721cba13b0538b7530c40/dummyApi/cuentas"));
      if(res.statusCode == HttpStatus.ok)
        return jsonDecode(res.body);
    } catch (e) {print(e);}
  }
}

