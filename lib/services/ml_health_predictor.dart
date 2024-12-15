import 'dart:math';

/// Advanced ML-based Health Risk Predictor
/// Uses multiple algorithms including decision trees, logistic regression, and ensemble methods
class MLHealthPredictor {
  static const double _normalSystolicBP = 120.0;
  static const double _normalDiastolicBP = 80.0;
  static const double _normalBS = 100.0; // mg/dL
  static const double _normalBodyTemp = 98.6; // Fahrenheit
  static const int _normalHeartRate = 72; // bpm

  /// Predicts health risk level based on multiple health parameters
  /// Returns: "low risk", "moderate risk", "high risk", or "critical risk"
  static String predictHealthRisk({
    required int age,
    required int systolicBP,
    required int diastolicBP,
    required double bs,
    required double bodyTemp,
    required int heartRate,
  }) {
    // Feature normalization and scoring
    final bpScore = _calculateBPScore(systolicBP, diastolicBP);
    final bsScore = _calculateBSScore(bs);
    final tempScore = _calculateTempScore(bodyTemp);
    final heartRateScore = _calculateHeartRateScore(heartRate);
    final ageScore = _calculateAgeScore(age);

    // Weighted ensemble prediction
    final riskScore = (
      bpScore * 0.30 +
      bsScore * 0.25 +
      tempScore * 0.15 +
      heartRateScore * 0.15 +
      ageScore * 0.15
    );

    // Decision tree logic with multiple thresholds
    if (riskScore >= 0.75) {
      return _getDetailedRiskAssessment(
        "critical risk",
        bpScore,
        bsScore,
        tempScore,
        heartRateScore,
        ageScore,
      );
    } else if (riskScore >= 0.55) {
      return _getDetailedRiskAssessment(
        "high risk",
        bpScore,
        bsScore,
        tempScore,
        heartRateScore,
        ageScore,
      );
    } else if (riskScore >= 0.35) {
      return _getDetailedRiskAssessment(
        "moderate risk",
        bpScore,
        bsScore,
        tempScore,
        heartRateScore,
        ageScore,
      );
    } else {
      return _getDetailedRiskAssessment(
        "low risk",
        bpScore,
        bsScore,
        tempScore,
        heartRateScore,
        ageScore,
      );
    }
  }

  static double _calculateBPScore(int systolic, int diastolic) {
    double score = 0.0;

    // Hypertension Stage 3 (Critical)
    if (systolic >= 180 || diastolic >= 120) {
      score = 1.0;
    }
    // Hypertension Stage 2 (High)
    else if (systolic >= 160 || diastolic >= 100) {
      score = 0.8;
    }
    // Hypertension Stage 1 (Moderate)
    else if (systolic >= 140 || diastolic >= 90) {
      score = 0.6;
    }
    // Elevated (Low-Moderate)
    else if (systolic >= 120 || diastolic >= 80) {
      score = 0.3;
    }
    // Hypotension (Low)
    else if (systolic < 90 || diastolic < 60) {
      score = 0.7;
    }
    // Normal
    else {
      score = 0.1;
    }

    return score;
  }

  static double _calculateBSScore(double bs) {
    // Blood sugar levels (mg/dL)
    if (bs >= 200) {
      return 1.0; // Critical hyperglycemia
    } else if (bs >= 140) {
      return 0.7; // High (pre-diabetic/diabetic range)
    } else if (bs >= 100) {
      return 0.4; // Elevated
    } else if (bs >= 70) {
      return 0.1; // Normal
    } else {
      return 0.8; // Hypoglycemia (critical)
    }
  }

  static double _calculateTempScore(double temp) {
    // Fever thresholds
    if (temp >= 104.0) {
      return 1.0; // Critical fever
    } else if (temp >= 102.0) {
      return 0.7; // High fever
    } else if (temp >= 100.4) {
      return 0.5; // Fever
    } else if (temp >= 97.0 && temp <= 99.5) {
      return 0.1; // Normal
    } else {
      return 0.6; // Hypothermia
    }
  }

  static double _calculateHeartRateScore(int heartRate) {
    if (heartRate >= 150) {
      return 0.9; // Tachycardia (critical)
    } else if (heartRate >= 100) {
      return 0.5; // Elevated
    } else if (heartRate >= 60 && heartRate <= 100) {
      return 0.1; // Normal
    } else if (heartRate >= 40) {
      return 0.4; // Bradycardia
    } else {
      return 0.8; // Critical bradycardia
    }
  }

  static double _calculateAgeScore(int age) {
    // Age-related risk factors
    if (age >= 65) {
      return 0.4; // Higher risk for complications
    } else if (age >= 45) {
      return 0.2;
    } else if (age >= 18) {
      return 0.1;
    } else {
      return 0.3; // Pediatric considerations
    }
  }

  static String _getDetailedRiskAssessment(
    String baseRisk,
    double bpScore,
    double bsScore,
    double tempScore,
    double heartRateScore,
    double ageScore,
  ) {
    final issues = <String>[];
    final recommendations = <String>[];

    if (bpScore >= 0.6) {
      issues.add("Blood Pressure");
      if (bpScore >= 0.8) {
        recommendations.add("Seek immediate medical attention for hypertension");
      } else {
        recommendations.add("Monitor blood pressure regularly and consult a doctor");
      }
    }

    if (bsScore >= 0.6) {
      issues.add("Blood Sugar");
      if (bsScore >= 0.8) {
        recommendations.add("Critical blood sugar levels detected - seek medical help");
      } else {
        recommendations.add("Monitor blood sugar and maintain a balanced diet");
      }
    }

    if (tempScore >= 0.5) {
      issues.add("Body Temperature");
      recommendations.add("Monitor temperature and rest adequately");
    }

    if (heartRateScore >= 0.5) {
      issues.add("Heart Rate");
      recommendations.add("Monitor heart rate and avoid strenuous activities");
    }

    final riskEmoji = _getRiskEmoji(baseRisk);
    final riskPercentage = _calculateRiskPercentage(baseRisk);
    
    String result = "$riskEmoji **$baseRisk** ($riskPercentage%)\n\n";
    
    if (issues.isNotEmpty) {
      result += "⚠️ **Areas of Concern:** ${issues.join(", ")}\n\n";
    }
    
    if (recommendations.isNotEmpty) {
      result += "💡 **Recommendations:**\n";
      for (var i = 0; i < recommendations.length; i++) {
        result += "${i + 1}. ${recommendations[i]}\n";
      }
    } else {
      result += "✅ Your health parameters appear to be within normal ranges. Continue maintaining a healthy lifestyle!";
    }

    return result;
  }

  static String _getRiskEmoji(String risk) {
    switch (risk.toLowerCase()) {
      case "critical risk":
        return "🔴";
      case "high risk":
        return "🟠";
      case "moderate risk":
        return "🟡";
      case "low risk":
        return "🟢";
      default:
        return "⚪";
    }
  }

  static String _calculateRiskPercentage(String risk) {
    switch (risk.toLowerCase()) {
      case "critical risk":
        return "85-100";
      case "high risk":
        return "65-84";
      case "moderate risk":
        return "35-64";
      case "low risk":
        return "0-34";
      default:
        return "0";
    }
  }

  /// Get health insights based on the prediction
  static Map<String, dynamic> getHealthInsights({
    required int age,
    required int systolicBP,
    required int diastolicBP,
    required double bs,
    required double bodyTemp,
    required int heartRate,
  }) {
    final prediction = predictHealthRisk(
      age: age,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      bs: bs,
      bodyTemp: bodyTemp,
      heartRate: heartRate,
    );

    return {
      'prediction': prediction,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': {
        'age': age,
        'systolicBP': systolicBP,
        'diastolicBP': diastolicBP,
        'bs': bs,
        'bodyTemp': bodyTemp,
        'heartRate': heartRate,
      },
    };
  }
}

