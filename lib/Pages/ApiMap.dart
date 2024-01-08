class ApiMap {
  String apiKey;
  String apiName;

  ApiMap({
    required this.apiKey,
    required this.apiName,
  });

  // Factory constructor to create an instance from a Map
  factory ApiMap.fromJson(Map<String, dynamic> json) {
    return ApiMap(
      apiKey: json['apiKey'],
      apiName: json['apiName'],
    );
  }

  // Method to convert the instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'apiKey': apiKey,
      'apiName': apiName,
    };
  }
}
