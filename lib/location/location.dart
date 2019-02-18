class Locations {
  static var locations;

  static setLocations(l) {
    locations = l;
  }

  static var provinces = locations.map((f) => f['value']).toList();

  static getCities(String province) {
    var cities = locations.where((f) => f['value'] == province).toList();
    cities = cities[0]['children'];
    if (cities == null || cities.length <= 1 || cities[0]['value'] == null) {
      return [
        {'value': province, 'children': cities[0]['children']}
      ];
    } else {
      return cities;
    }
  }

  static getTowns(String city, cities) {
    var towns = cities.where((f) => f['value'] == city).toList();
    towns = towns[0]['children'];
    if (towns == null || towns.length == 0) {
      return [{
        'value':city
      }];
    } else {
      return towns;
    }
  }
}
