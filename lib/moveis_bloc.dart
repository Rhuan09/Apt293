import 'package:flutter_bloc/flutter_bloc.dart';
import 'moveis_data_provider.dart';
import 'package:image_picker/image_picker.dart';

class MoveisBloc extends Bloc<MoveisEvent, MoveisState> {
  final MoveisDataProvider dataProvider;

  MoveisBloc(this.dataProvider) : super(MoveisInitial()) {
    on<ListarMoveisEvent>((event, emit) async {
      try {
        List<Map<String, dynamic>> moveis =
            await dataProvider.getMoveis(event.apartmentId);
        emit(MoveisListadosState(moveis));
      } catch (e) {
        emit(MovelErrorState(e.toString()));
      }
    });

    on<AdicionarMovelEvent>((event, emit) async {
      try {
        await dataProvider.addMovel(
            event.apartmentId, event.movel, event.imagemMovel);
        List<Map<String, dynamic>> moveis =
            await dataProvider.getMoveis(event.apartmentId);
        emit(MoveisListadosState(moveis));
      } catch (e) {
        emit(MovelErrorState(e.toString()));
      }
    });

    on<AtualizarMovelEvent>((event, emit) async {
      try {
        await dataProvider.updateMovel(
            event.apartmentId, event.movelAntigo, event.movelNovo);
        List<Map<String, dynamic>> moveis =
            await dataProvider.getMoveis(event.apartmentId);
        emit(MoveisListadosState(moveis));
      } catch (e) {
        emit(MovelErrorState(e.toString()));
      }
    });

    on<RemoverMovelEvent>((event, emit) async {
      try {
        await dataProvider.removeMovel(event.apartmentId, event.movel);
        List<Map<String, dynamic>> moveis =
            await dataProvider.getMoveis(event.apartmentId);
        emit(MoveisListadosState(moveis));
      } catch (e) {
        emit(MovelErrorState(e.toString()));
      }
    });
  }
}

class MoveisInitial extends MoveisState {}

class MoveisListadosState extends MoveisState {
  final List<Map<String, dynamic>> moveis;

  MoveisListadosState(this.moveis);
}

class MovelErrorState extends MoveisState {
  final String message;

  MovelErrorState(this.message);
}

abstract class MoveisState {}

abstract class MoveisEvent {}

class ListarMoveisEvent extends MoveisEvent {
  final String apartmentId;

  ListarMoveisEvent(this.apartmentId);
}

class AdicionarMovelEvent extends MoveisEvent {
  final String movel;
  final String apartmentId;
  final XFile? imagemMovel;

  AdicionarMovelEvent(this.movel, this.apartmentId, this.imagemMovel);
}

class AtualizarMovelEvent extends MoveisEvent {
  final String movelAntigo;
  final String movelNovo;
  final String apartmentId;

  AtualizarMovelEvent(this.movelAntigo, this.movelNovo, this.apartmentId);
}

class RemoverMovelEvent extends MoveisEvent {
  final String movel;
  final String apartmentId;

  RemoverMovelEvent(this.movel, this.apartmentId);
}
