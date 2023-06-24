import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:att_2_flutter/DataProviders/apartamentos_data_provider.dart';

class ApartmentBloc extends Bloc<ApartmentEvent, ApartmentState> {
  final ApartamentosDataProvider dataProvider;
  final String userId;

  ApartmentBloc(this.dataProvider, this.userId)
      : super(ApartmentState([], null));

  @override
  Stream<ApartmentState> mapEventToState(ApartmentEvent event) async* {
    if (event is LoadApartments) {
      // Carrega os apartamentos do usuário do Cloud Firestore
      List<String> apartments = await dataProvider.getApartments(userId);
      yield ApartmentState(apartments, state.selectedApartment);
    } else if (event is AddApartment) {
      // Adiciona um novo apartamento ao Cloud Firestore
      await dataProvider.addApartment(userId, event.apartment);
      List<String> apartments = List.from(state.apartments)
        ..add(event.apartment);
      yield ApartmentState(apartments, state.selectedApartment);
    } else if (event is RemoveApartment) {
      // Remove um apartamento do Cloud Firestore
      await dataProvider.removeApartment(userId, event.apartment);
      List<String> apartments = List.from(state.apartments)
        ..remove(event.apartment);
      yield ApartmentState(apartments, state.selectedApartment);
    } else if (event is SelectApartment) {
      // Atualiza o estado do apartamento selecionado
      yield ApartmentState(state.apartments, event.apartment);
    }
  }
}

class ApartmentState {
  final List<String> apartments;
  final String? selectedApartment;

  ApartmentState(this.apartments, this.selectedApartment);
}

class SelectApartment extends ApartmentEvent {
  final String apartment;

  SelectApartment(this.apartment);
}

abstract class ApartmentEvent {}

class LoadApartments extends ApartmentEvent {}

class AddApartment extends ApartmentEvent {
  final String apartment;

  AddApartment(this.apartment);
}

class RemoveApartment extends ApartmentEvent {
  final String apartment;

  RemoveApartment(this.apartment);
}
