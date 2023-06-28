import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:att_2_flutter/DataProviders/gastosvariaveis_data_provider.dart';

class GastosVariaveisBloc
    extends Bloc<GastosVariaveisEvent, GastosVariaveisState> {
  final GastosVariaveisDataProvider dataProvider;

  GastosVariaveisBloc(this.dataProvider) : super(GastosVariaveisInitial()) {
    on<ListarGastosVariaveisEvent>((event, emit) async {
      try {
        List<Map<String, dynamic>> gastosvariaveis =
            await dataProvider.getGastos(event.apartmentId);
        emit(GastosVariaveisListadosState(gastosvariaveis));
      } catch (e) {
        emit(GastosVariaveisErrorState(e.toString()));
      }
    });

    on<AdicionarGastosVariaveisEvent>((event, emit) async {
      try {
        await dataProvider.addGastos(
            event.apartmentId, event.gasto, event.tipo, event.valor);
        List<Map<String, dynamic>> gastosvariaveis =
            await dataProvider.getGastos(event.apartmentId);
        emit(GastosVariaveisListadosState(gastosvariaveis));
      } catch (e) {
        emit(GastosVariaveisErrorState(e.toString()));
      }
    });

    on<AtualizarGastosVariaveisEvent>((event, emit) async {
      try {
        await dataProvider.updateGastos(event.apartmentId,
            event.gastoVariavelAntigo, event.gastoVariavelNovo);
        List<Map<String, dynamic>> gastosvariaveis =
            await dataProvider.getGastos(event.apartmentId);
        emit(GastosVariaveisListadosState(gastosvariaveis));
      } catch (e) {
        emit(GastosVariaveisErrorState(e.toString()));
      }
    });

    on<RemoveGastoVariavelEvent>((event, emit) async {
      try {
        await dataProvider.removeGasto(event.gastoId);
        List<Map<String, dynamic>> gastosvariaveis =
            await dataProvider.getGastos(event.apartmentId);
        emit(GastosVariaveisListadosState(gastosvariaveis));
      } catch (e) {
        emit(GastosVariaveisErrorState(e.toString()));
      }
    });
  }
}

class GastosVariaveisInitial extends GastosVariaveisState {}

class GastosVariaveisListadosState extends GastosVariaveisState {
  final List<Map<String, dynamic>> gastosvariaveis;

  GastosVariaveisListadosState(this.gastosvariaveis);
}

class GastosVariaveisErrorState extends GastosVariaveisState {
  final String message;
  GastosVariaveisErrorState(this.message);
}

abstract class GastosVariaveisState {}

abstract class GastosVariaveisEvent {}

class ListarGastosVariaveisEvent extends GastosVariaveisEvent {
  final String apartmentId;

  ListarGastosVariaveisEvent(this.apartmentId);
}

class AdicionarGastosVariaveisEvent extends GastosVariaveisEvent {
  final String gasto;
  final String apartmentId;
  final String tipo;
  final String valor;

  AdicionarGastosVariaveisEvent(
      this.gasto, this.apartmentId, this.tipo, this.valor);
}

class AtualizarGastosVariaveisEvent extends GastosVariaveisEvent {
  final String gastoVariavelAntigo;
  final String gastoVariavelNovo;
  final String apartmentId;

  AtualizarGastosVariaveisEvent(
      this.gastoVariavelAntigo, this.gastoVariavelNovo, this.apartmentId);
}

class RemoveGastoVariavelEvent extends GastosVariaveisEvent {
  final String gastoId;
  final String apartmentId;

  RemoveGastoVariavelEvent(this.gastoId, this.apartmentId);
}
