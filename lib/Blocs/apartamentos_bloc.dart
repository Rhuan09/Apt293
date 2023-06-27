import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:att_2_flutter/DataProviders/apartamentos_data_provider.dart';

class ApartmentBloc extends Bloc<ApartmentEvent, ApartmentState> {
  final ApartamentosDataProvider dataProvider;
  final String userId;

  ApartmentBloc(this.dataProvider, this.userId)
      : super(ApartmentState([], null)) {
    print('ApartmentBloc constructor called with userId: $userId');

    on<LoadApartments>((event, emit) async {
      print('Handling LoadApartments event');
      // Carrega os apartamentos do usuário do Cloud Firestore
      List<String> apartments = await dataProvider.getApartments(userId);
      emit(ApartmentState(apartments, state.selectedApartment));
    });

    on<AddApartment>((event, emit) async {
      print('Handling AddApartment event');
      // Adiciona um novo apartamento ao Cloud Firestore
      await dataProvider.addApartment(userId, event.apartment);
      List<String> apartments = List.from(state.apartments)
        ..add(event.apartment);
      emit(ApartmentState(apartments, state.selectedApartment));
    });

    on<RemoveApartment>((event, emit) async {
      print('Handling RemoveApartment event');
      // Remove um apartamento do Cloud Firestore
      await dataProvider.removeApartment(userId, event.apartment);
      List<String> apartments = List.from(state.apartments)
        ..remove(event.apartment);
      emit(ApartmentState(apartments, state.selectedApartment));
    });

    on<SelectApartment>((event, emit) {
      print('Handling SelectApartment event');
      // Atualiza o estado do apartamento selecionado
      emit(ApartmentState(state.apartments, event.apartment));
    });
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

class Apartment {
  final String id;
  final String name;

  Apartment({required this.id, required this.name});
}
