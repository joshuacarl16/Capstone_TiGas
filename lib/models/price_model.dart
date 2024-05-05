class Price {
  final int id;
  final String uploadedBy;
  final Map<String, double>
      gasTypeInfo; // Updated to use a map for gas type info
  final DateTime uploadedAt;
  final int stationId;

  Price({
    required this.id,
    required this.uploadedBy,
    required this.gasTypeInfo,
    required this.uploadedAt,
    required this.stationId,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    // Extract gas type info from JSON and convert to Map<String, double>
    Map<String, dynamic> gasTypeMap = json['gasTypeInfo'];
    Map<String, double> formattedGasTypeInfo = {};
    gasTypeMap.forEach((key, value) {
      formattedGasTypeInfo[key] = double.parse(value.toString());
    });

    return Price(
      id: json['id'],
      uploadedBy: json['uploaded_by'],
      gasTypeInfo: formattedGasTypeInfo,
      uploadedAt:
          DateTime.parse(json['updated']), // Use 'updated' field for uploadedAt
      stationId: json['station'],
    );
  }
}
