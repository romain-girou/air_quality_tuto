class AirQuality {
	int aqi;
	String cityName;
	String? message;
	String? emojiRef;

	AirQuality({
    required this.aqi,
    required this.cityName,
		this.message,
		this.emojiRef,
  });

	// Named constructor for creating an AirQuality instance from a Map
  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      aqi: json['data']['aqi'] as int,
      cityName: json['data']['city']['name'] as String,
    );
  }

	// Overriding the toString method to provide a custom string representation of the AirQuality object
  @override
  String toString() {
    return 'AirQuality(aqi: $aqi, cityName: $cityName, message: $message, emojiRef: $emojiRef)';
  }
}