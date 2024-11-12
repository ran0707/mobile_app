// lib/services/user_data_store.dart
class UserDataStore {
  static final UserDataStore _instance = UserDataStore._internal();
  factory UserDataStore() => _instance;
  UserDataStore._internal();

  // Temporary storage for user registration data
  String? name;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? country;

  void storeUserData({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
  }) {
    this.name = name;
    this.phone = phone;
    this.address = address;
    this.city = city;
    this.state = state;
    this.country = country;
  }

  void clear() {
    name = null;
    phone = null;
    address = null;
    city = null;
    state = null;
    country = null;
  }
}