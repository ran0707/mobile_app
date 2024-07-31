import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location service are disabled');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('location permission denied');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permission are permanently denied');
    }
    return await Geolocator.getCurrentPosition();
  }
  Future<Address> getAddressFromLatLng(Position position) async {
    GeoCode geoCode = GeoCode();
    var address = await geoCode.reverseGeocoding(latitude: position.latitude, longitude: position.longitude);
    return address;
  }

  Future<Position> _determinePosition(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      throw Exception('Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied forever')),
      );
      throw Exception('Location permission denied forever');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      throw Exception('Location services are disabled');
    }

    // If all permissions and services are good, get current position
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      for (Placemark placemark in placemarks) {
        print('Name: ${placemark.name}');
        print('Street: ${placemark.street}');
        print('ISO Country Code: ${placemark.isoCountryCode}');
        print('Country: ${placemark.country}');
        print('Postal code: ${placemark.postalCode}');
        print('Administrative area: ${placemark.administrativeArea}');
        print('Subadministrative area: ${placemark.subAdministrativeArea}');
        print('Locality: ${placemark.locality}');
        print('Sublocality: ${placemark.subLocality}');
        print('Thoroughfare: ${placemark.thoroughfare}');
        print('Subthoroughfare: ${placemark.subThoroughfare}');
        print('');
      }
    } catch (e) {
      print('Error fetching address: $e');
    }



}}