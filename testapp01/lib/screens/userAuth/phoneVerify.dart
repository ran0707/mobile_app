import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:testapp01/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:testapp01/localization/app_localizations.dart';
import 'package:testapp01/screens/dashboard/home.dart';
import 'package:testapp01/screens/userAuth/userverify.dart';
import '../../bloc/phone_verification/phone_verification_bloc.dart';
import '../../bloc/phone_verification/phone_verification_event.dart';
import '../../bloc/phone_verification/phone_verification_state.dart';
import 'otpverify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneVerification extends StatefulWidget {

//final String location;

  const PhoneVerification({super.key});
  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhoneVerificationBloc(),
      child: PhoneVerificationForm(),
    );
  }
}

class PhoneVerificationForm extends StatefulWidget {
  @override
  _PhoneVerificationFormState createState() => _PhoneVerificationFormState();
}

class _PhoneVerificationFormState extends State<PhoneVerificationForm> {
  final _mobileController = TextEditingController();
  final _nameController = TextEditingController();
  final street = TextEditingController();
  final city = TextEditingController();
  final country = TextEditingController();
  final postalcode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;



  String? _errorMessage;




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
      String getStreetAddress(){
        String street = " ";
        if(place.street != null && place.street!.isNotEmpty){
          street += place.street! + " ";
        }
        if(place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty){
          street += place.subThoroughfare! + "";
        }
        if(place.thoroughfare != null && place.thoroughfare!.isNotEmpty){
          street += place.thoroughfare!;
        }
        return street.trim();
      }

      // street.text =
      // '${place.street ?? ''} ${place.subThoroughfare ?? ''}, ${place.thoroughfare ?? ''}  ';
      street.text = getStreetAddress();
      city.text = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
      country.text = place.country ?? '';
      postalcode.text = place.postalCode ?? '';

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpVerification(locality: place.locality ?? 'Unknown',),));
    }catch(e){
      print('Error fetching address: $e');
    }
    setState(() { isLoading = false; });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(FlutterI18n.translate(context,'app-name') ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               Text(FlutterI18n.translate(
                context,"phone_verification",) ,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              BlocConsumer<PhoneVerificationBloc, PhoneVerificationState>(
                listener: (context, state) {
                  if (state is PhoneVerificationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  } else if (state is PhoneVerificationSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OtpVerification(locality: city.text.split(',').first,),
                    ));
                  } else if(state is PhoneVerificationLoading){
                    setState(() {
                      isLoading = true;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is PhoneInvalid) {
                    _errorMessage = 'Enter valid phone no';
                  } else {
                    _errorMessage = null;
                  }
                  //print('current state: $state');
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          //maxLength: 10,
                          decoration: const InputDecoration(
                            labelText: 'your name',
                            prefixIcon: Icon(CupertinoIcons.profile_circled),
                            //prefixText: '+91 ',
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: IntlPhoneField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          //maxLength: 10,
                          decoration: const InputDecoration(
                            labelText: 'Phone no',
                            prefixIcon: Icon(CupertinoIcons.phone),
                            //prefixText: '+91 ',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            //print('phone no input changed: $value');
                            context
                                .read<PhoneVerificationBloc>()
                                .add(ValidatePhoneNumber(phone.completeNumber));
                          },
                        ),
                      ),
                        OutlinedButton(
                          onPressed: () async{
                            try{
                              Position position = await _determinePosition();
                              print(position.latitude);
                              print(position.longitude);
                              print(position.altitude);
                              await GetAddressFromCoor(position);
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  isLoading = true;
                                });
                                context
                                    .read<PhoneVerificationBloc>()
                                    .add(RequestOtp(_mobileController.text, _nameController.text, street.text, city.text, country.text, postalcode.text));
                              }
                            }catch(e){
                              print(e);
                            }

                          },
                          child: const Text('Get OTP'),

                        ),
                      if (isLoading)
                        CircularProgressIndicator(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
