import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:att_2_flutter/DataProviders/gastosfixos_data_provider.dart';
import 'apartamentos_bloc.dart';

// Definir os eventos do Bloc
abstract class GastosFixosEvent {}

class ApartamentoSelecionado extends GastosFixosEvent {
  final String? apartamento;

  ApartamentoSelecionado(this.apartamento);
}

class AdicionarGasto extends GastosFixosEvent {
  final String tipo;
  final double valor;

  AdicionarGasto(this.tipo, this.valor);
}

// Definir os estados do Bloc
abstract class GastosFixosState {}

class GastosFixosInitial extends GastosFixosState {}

class GastosFixosLoading extends GastosFixosState {}

class GastosFixosLoaded extends GastosFixosState {
  final Map<String, double> gastosFixos;

  GastosFixosLoaded(this.gastosFixos);
}

class GastosFixosError extends GastosFixosState {}

// Definir o Bloc
class GastosFixosBloc extends Bloc<GastosFixosEvent, GastosFixosState> {
  final GastosFixosDataProvider dataProvider;
  final ApartmentBloc apartmentBloc;

  GastosFixosBloc({required this.dataProvider, required this.apartmentBloc})
      : super(GastosFixosInitial()) {
    on<ApartamentoSelecionado>(_mapApartamentoSelecionadoToState);
    on<AdicionarGasto>(_mapAdicionarGastoToState);
  }

  Future<void> _mapApartamentoSelecionadoToState(
      ApartamentoSelecionado event, Emitter<GastosFixosState> emit) async {
    print('Evento ApartamentoSelecionado disparado');
    emit(GastosFixosLoading());
    try {
      final apartamento = apartmentBloc.state.selectedApartment;
      if (apartamento != null) {
        final gastosFixos = await dataProvider.fetchGastosFixos(apartamento);
        emit(GastosFixosLoaded(gastosFixos));
      } else {
        emit(GastosFixosError());
      }
    } catch (_) {
      emit(GastosFixosError());
    }
  }

  Future<void> _mapAdicionarGastoToState(
      AdicionarGasto event, Emitter<GastosFixosState> emit) async {
    if (state is GastosFixosLoaded) {
      final currentState = state as GastosFixosLoaded;
      final updatedGastosFixos =
          Map<String, double>.from(currentState.gastosFixos);
      updatedGastosFixos[event.tipo] = event.valor;
      emit(GastosFixosLoaded(updatedGastosFixos));

      // Salvar os dados dos gastos fixos no Firestore
      final apartamento = apartmentBloc.state.selectedApartment;
      if (apartamento != null) {
        await dataProvider.saveGastosFixos(apartamento, updatedGastosFixos);
      }
    }
  }
}
