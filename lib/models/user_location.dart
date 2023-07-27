class UserLocation {
  static final UserLocation _singleton = UserLocation._internal();
  factory UserLocation() {
    return _singleton;
  }
  UserLocation._internal();

  double? latitude;
  double? longitude;

  void updateLocation(double newLat, double newLong) {
    this.latitude = newLat;
    this.longitude = newLong;
  }
}
