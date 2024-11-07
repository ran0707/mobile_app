// location_bloc.dart
import 'dart:convert';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:testapp01/bloc/user_verification/user_verification_event.dart';
import 'package:testapp01/bloc/user_verification/user_verification_state.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {

  //final PhoneVerificationBloc phoneVerificationBloc;

  LocationBloc() : super(const LocationState()) {
    on<FetchLocation>(_onFetchLocation);
  }

  Future<void> _onFetchLocation(FetchLocation event, Emitter<LocationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        emit(state.copyWith(
          streetCity: '${place.street ?? ''}, ${place.locality ?? ''}',
          adminLocality: '${place.administrativeArea ?? ''}, ${place.subAdministrativeArea ?? ''}',
          country: place.country ?? '',
          postalCode: place.postalCode ?? '',
          isLoading: false,
        ));

        await _saveLocationData(
          streetCity: '${place.street ?? ''}, ${place.locality ?? ''}',
          adminLocality: '${place.administrativeArea ?? ''}, ${place.subAdministrativeArea ?? ''}',
          country: place.country ?? '',
          postalCode: place.postalCode ?? '',
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }


  Future<void> _saveLocationData({
    required String streetCity,
    required String adminLocality,
    required String country,
    required String postalCode,
})async{
    final url = Uri.parse('http://10.0.2.2:3000/api/users/phone');
    try{
      final res = await http.post(
        url,
        headers: {'Content-Type':'application/json'},
        body: json.encode({
          'streetCity':streetCity,
          'adminLocality':adminLocality,
          'country':country,
          'postalCode':postalCode
        }),
      );
      if(res.statusCode == 200){
        print('data saved successfully');
      }else{
        // print('Failed to save data: ${res.statusCode}');
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content:Text('somethig went wrong '),
        // ));
      }
    }catch(e){}
}

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
