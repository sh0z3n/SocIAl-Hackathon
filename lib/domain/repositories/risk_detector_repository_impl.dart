import 'package:dio/dio.dart';
import 'package:safe_bump/services/ml_health_predictor.dart';

import '../../data/repositories/risk_detector_repository.dart';

class RiskDetectorRepositoryImpl extends RiskDetectorRepository {
  final Dio _dio;

  RiskDetectorRepositoryImpl(this._dio);

  @override
  Future<String> fetchData(int age, int systolicBP, int diastolicBP, double bs,
      double bodyTemp, int heartRate) async {
    try {
      // Use local ML model instead of external API
      final prediction = MLHealthPredictor.predictHealthRisk(
        age: age,
        systolicBP: systolicBP,
        diastolicBP: diastolicBP,
        bs: bs,
        bodyTemp: bodyTemp,
        heartRate: heartRate,
      );
      
      return prediction;
    } on Exception catch (e) {
      print(e);
      return "Error: Unable to process health prediction. Please try again.";
    }
  }
}
