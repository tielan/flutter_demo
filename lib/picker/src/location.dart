class Locations {
  static List locations;

  static setLocations(data) {
    locations = data;
  }

  static List getProvinces() {
    return locations;
  }

  static int getProvincesIndex(String province) {
    int index = locations.indexWhere((c) => c['value'].indexOf(province) >= 0);
    return index >= 0 ? index : 0;
  }

  static List getCities(Map province) {
    var cities = province['children'];
    if (cities == null || cities.length <= 1 || cities[0]['value'] == null) {
      return [];
    } else {
      return cities;
    }
  }

  static int getCitieIndex(String city,List cities) {
    int index = cities.indexWhere((c) => c['value'].indexOf(city) >= 0);
    return index >= 0 ? index : 0;
  }

  static List getTowns(Map city) {
    var towns = city['children'];
    if (towns == null || towns.length == 0) {
      return [city];
    } else {
      return towns;
    }
  }

  static int getTownIndex(String town,List towns) {
    if (towns == null) {
      return 0;
    }
    int index = towns.indexWhere((c) => c['value'].indexOf(town) >= 0);
    return index >= 0 ? index : 0;
  }
}
