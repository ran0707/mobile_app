import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:testapp01/bloc/user_verification/user_verification_bloc.dart';
import 'package:testapp01/bloc/user_verification/user_verification_state.dart';


class UserVerification extends StatefulWidget {
  //final PhoneVerificationBloc phoneVerificationBloc;
  const UserVerification({super.key});

  @override
  State<UserVerification> createState() => _UserVerificationState();
}

class _UserVerificationState extends State<UserVerification> {
  //String location = '';
  final TextEditingController street = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController postalcode = TextEditingController();
  bool isLoading = false;

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Show a dialog or snackbar informing user about denied permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permission is denied. Please enable it to use this feature.')),
      );
      return Future.error('Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
      // Handle permanently denied case
      return Future.error('Location permission denied forever');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }

    // If all permissions and services are good, get current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromCoor(Position position) async {
    setState(() {
      isLoading = true;
    });
   try{
     List<Placemark> placemark =
     await placemarkFromCoordinates(position.latitude, position.longitude);
     print(placemark);
     Placemark place = placemark.first;
     // ${place.subLocality ?? ''},${place.administrativeArea ?? ''},${place.country ?? ''},${place.postalCode ?? ''}
     street.text =
     '${place.street ?? ''} ${place.subThoroughfare ?? ''}, ${place.thoroughfare ?? ''}  ';
     city.text = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
     country.text = place.country ?? '';
     postalcode.text = place.postalCode ?? '';
   }catch(e){
     print('Error fetching address: $e');
   }
    setState(() { isLoading = false; });
  }

  @override
  void dispose() {
    street.dispose();
    city.dispose();
    country.dispose();
    postalcode.dispose();
    super.dispose();
  }
 bool get isFormValid {
    return street.text.isNotEmpty && city.text.isNotEmpty && country.text.isNotEmpty && postalcode.text.isNotEmpty;
 }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Address Verification'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if ( isLoading) {
                return  const Center(child: CircularProgressIndicator());
              }
              if (state.error.isNotEmpty) {
                return Center(child: Text(state.error));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'street',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      controller: street,
//readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "city",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      controller: city,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "country",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      controller: country,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "postal code",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      controller: postalcode,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                          onPressed: () async {
                            try {
                              Position position = await _determinePosition();
                              print(position.latitude);
                              print(position.longitude);
                              print(position.altitude);

//location = 'lat:${position.latitude}, long: ${position.longitude}, acc: ${position.accuracy}';
                              await GetAddressFromCoor(position);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Text('Fetch location')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.green[400],
                          ),
                          onPressed: isFormValid ?  () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => Home(locality: locality,)));
                          } :null,
                          child: const Text('save and Next'))
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
