dynamic getValueFromMap(Map<String, dynamic> map, String key) {
  print(map);
  var result;
  map.forEach((k, value) {
    if (k == key) {
      result = value;
    }
  });
  return result;
}

dynamic getValueFromMapData(Map<String, dynamic> map, String key) {
  print(map);
  var result;
  map['data'].forEach((k, value) {
    if (k == key) {
      result = value;
    }
  });
  return result;
}

