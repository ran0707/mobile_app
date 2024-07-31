// location_state.dart
import 'package:equatable/equatable.dart';

class LocationState extends Equatable {
  final String streetCity;
  final String adminLocality;
  final String country;
  final String postalCode;
  final bool isLoading;
  final String error;

  const LocationState({
    this.streetCity = '',
    this.adminLocality = '',
    this.country = '',
    this.postalCode = '',
    this.isLoading = false,
    this.error = '',
  });

  LocationState copyWith({
    String? streetCity,
    String? adminLocality,
    String? country,
    String? postalCode,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      streetCity: streetCity ?? this.streetCity,
      adminLocality: adminLocality ?? this.adminLocality,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [streetCity, adminLocality, country, postalCode, isLoading, error];
}





























// import 'package:equatable/equatable.dart';
//
//
// abstract class UserVerificationState extends Equatable{
//
//   @override
//   List<Object> get props =>[];
// }
//
//
// class UserVerificationInitial extends UserVerificationState{ }
//
// class UserVerificationLoading extends UserVerificationState { }
//
// class UserVerificationLoaded extends UserVerificationState {
//   final String address;
//
//   UserVerificationLoaded(this.address);
//
//   @override
//   List<Object> get props =>[address];
// }
//
// class UserVerificationError extends UserVerificationState{
//   final String error;
//
//   UserVerificationError(this.error);
//
//   @override
//   List<Object> get props =>[error];
// }