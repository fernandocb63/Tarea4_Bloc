part of 'cuentas_bloc.dart';

abstract class CuentasEvent extends Equatable {
  const CuentasEvent();

  @override
  List<Object> get props => [];
}

class CuentasCambiar extends CuentasEvent {}
