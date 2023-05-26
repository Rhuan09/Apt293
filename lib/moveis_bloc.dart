import 'package:flutter_bloc/flutter_bloc.dart';
import 'moveis_data_provider.dart';

class MoveisBloc extends Bloc<MoveisEvent, MoveisState> {
  final MoveisDataProvider _dataProvider;

  MoveisBloc(this._dataProvider) : super(MoveisInitial()) {
    initialize();

    on<AdicionarMovelEvent>((event, emit) async {
      try {
        await _dataProvider.adicionarMovel(event.nomeMovel);
        final moveis = await _dataProvider.listarMoveis();
        emit(MoveisListadosState(moveis: moveis));
      } catch (e) {
        emit(MovelErrorState(message: 'Erro ao adicionar móvel.'));
      }
    });

    on<ListarMoveisEvent>((event, emit) async {
      try {
        final moveis = await _dataProvider.listarMoveis();
        emit(MoveisListadosState(moveis: moveis));
      } catch (e) {
        emit(MovelErrorState(message: 'Erro ao listar móveis.'));
      }
    });

    on<RemoverMovelEvent>((event, emit) async {
      try {
        await _dataProvider.removerMovel(event.nomeMovel);
        final moveis = await _dataProvider.listarMoveis();

        emit(MoveisListadosState(moveis: moveis));
      } catch (e) {
        emit(MovelErrorState(message: 'Erro ao remover móvel.'));
      }
    });

    on<AtualizarMovelEvent>((event, emit) async {
      try {
        await _dataProvider.atualizarMovel(
            event.nomeMovelAntigo, event.nomeMovelNovo);
        final moveis = await _dataProvider.listarMoveis();

        emit(MoveisListadosState(moveis: moveis));
      } catch (e) {
        emit(MovelErrorState(message: 'Erro ao atualizar móvel.'));
      }
    });

    void loadMoveis() async {
      try {
        final moveis = await _dataProvider.listarMoveis();
        emit(MoveisListadosState(moveis: moveis));
      } catch (e) {
        emit(MovelErrorState(message: 'Erro ao listar móveis.'));
      }
    }
  }

  void initialize() async {
    try {
      final moveis = await _dataProvider.listarMoveis();
      emit(MoveisListadosState(moveis: moveis));
    } catch (e) {
      emit(MovelErrorState(message: 'Erro ao listar móveis.'));
    }
  }
}
// Events

abstract class MoveisEvent {}

class AdicionarMovelEvent extends MoveisEvent {
  final String nomeMovel;

  AdicionarMovelEvent(this.nomeMovel);
}

class ListarMoveisEvent extends MoveisEvent {}

class RemoverMovelEvent extends MoveisEvent {
  final String nomeMovel;

  RemoverMovelEvent(this.nomeMovel);
}

class AtualizarMovelEvent extends MoveisEvent {
  final String nomeMovelAntigo;
  final String nomeMovelNovo;

  AtualizarMovelEvent(this.nomeMovelAntigo, this.nomeMovelNovo);
}

// States

abstract class MoveisState {}

class MoveisInitial extends MoveisState {}

class MovelAdicionadoState extends MoveisState {}

class MoveisListadosState extends MoveisState {
  final List<String> moveis;

  MoveisListadosState({required this.moveis});
}

class MovelRemovidoState extends MoveisState {}

class MovelAtualizadoState extends MoveisState {}

class MovelErrorState extends MoveisState {
  final String message;

  MovelErrorState({required this.message});
}
