// location_event.dart
import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class FetchLocation extends LocationEvent {}





























// import 'package:equatable/equatable.dart';
//
//
// abstract class UserVerificationEvent extends Equatable{
//
//   @override
//   List<Object> get props =>[];
// }
//
// class UserNameChanged extends UserVerificationEvent{
//   final String name;
//
//   UserNameChanged(this.name);
//
//   @override
//   List<Object> get props =>[name];
// }
//
// class EmailChanged extends UserVerificationEvent{
//   final String email;
//   EmailChanged(this.email);
//
//   @override
//   List<Object> get props =>[email];
//
// }
//
// class PincodeChanged extends UserVerificationEvent{
//   final String pincode;
//
//   PincodeChanged(this.pincode);
//
//   @override
//   List<Object> get props =>[pincode];
//
// }
//
// class FetchAddressFromPincode extends UserVerificationEvent{ }
//
// class FetchUserLocation extends UserVerificationEvent {}
//
// class VerifyUser extends UserVerificationEvent { }
//
//
//
