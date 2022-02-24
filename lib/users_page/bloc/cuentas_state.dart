part of 'cuentas_bloc.dart';

abstract class CuentasState extends Equatable {
  const CuentasState();

  @override
  List<Object> get props => [];
}

class CuentasInitial extends CuentasState {}

class CuentasErrorState extends CuentasState {
  final String errorMsg;

  CuentasErrorState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class CuentaSelected extends CuentasState {
  final Map cuentamap;

  CuentaSelected({required this.cuentamap});

  @override
  List<Object> get props => [];
}