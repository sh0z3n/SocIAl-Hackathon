import 'dart:math';

/// AI Chat Assistant Service for Pregnancy Health Questions
/// Uses intelligent pattern matching and knowledge base
class AIChatService {
  static final List<Map<String, dynamic>> _knowledgeBase = [
    {
      'keywords': ['period', 'menstrual', 'cycle', 'menstruation'],
      'responses': [
        'A normal menstrual cycle typically ranges from 21 to 35 days, with the average cycle lasting around 28 days.',
        'Common causes of irregular periods include hormonal imbalances, stress, excessive exercise, weight changes, thyroid disorders, and certain medical conditions.',
        'Menstrual cramps can be alleviated through various methods including over-the-counter pain relievers, applying heat to the abdomen, gentle exercise, relaxation techniques, and dietary changes.',
      ],
    },
    {
      'keywords': ['pregnancy', 'pregnant', 'baby', 'fetus'],
      'responses': [
        'During pregnancy, it\'s important to maintain a balanced diet rich in folic acid, iron, calcium, and protein.',
        'Regular prenatal check-ups are essential for monitoring both your health and your baby\'s development.',
        'Common pregnancy symptoms include morning sickness, fatigue, mood swings, and food cravings. These are usually normal, but consult your doctor if concerned.',
        'Staying hydrated, getting adequate rest, and gentle exercise like walking or prenatal yoga can help manage pregnancy discomforts.',
      ],
    },
    {
      'keywords': ['exercise', 'workout', 'fitness', 'activity'],
      'responses': [
        'During pregnancy, low to moderate intensity exercises like walking, swimming, and prenatal yoga are generally safe and beneficial.',
        'Avoid high-impact activities, contact sports, and exercises that involve lying flat on your back after the first trimester.',
        'Listen to your body and stop if you feel dizzy, short of breath, or experience any pain.',
        'Aim for at least 30 minutes of moderate exercise most days of the week, unless your doctor advises otherwise.',
      ],
    },
    {
      'keywords': ['nutrition', 'diet', 'food', 'eat', 'meal'],
      'responses': [
        'Focus on whole foods: fruits, vegetables, lean proteins, whole grains, and dairy products.',
        'Avoid raw fish, unpasteurized dairy, deli meats, and excessive caffeine during pregnancy.',
        'Stay hydrated by drinking plenty of water throughout the day.',
        'Small, frequent meals can help manage nausea and maintain stable blood sugar levels.',
      ],
    },
    {
      'keywords': ['symptom', 'pain', 'ache', 'discomfort'],
      'responses': [
        'Some discomfort is normal during pregnancy, but always consult your healthcare provider about persistent or severe symptoms.',
        'Common pregnancy discomforts include back pain, round ligament pain, and Braxton Hicks contractions.',
        'If you experience severe abdominal pain, bleeding, or difficulty breathing, seek medical attention immediately.',
      ],
    },
    {
      'keywords': ['vitamin', 'supplement', 'prenatal'],
      'responses': [
        'Prenatal vitamins are important for ensuring you get essential nutrients like folic acid, iron, and calcium.',
        'Folic acid is especially crucial in early pregnancy for preventing neural tube defects.',
        'Always consult your doctor before taking any supplements during pregnancy.',
      ],
    },
    {
      'keywords': ['sleep', 'rest', 'tired', 'fatigue'],
      'responses': [
        'Fatigue is very common during pregnancy, especially in the first and third trimesters.',
        'Try to maintain a regular sleep schedule and create a comfortable sleep environment.',
        'Sleeping on your left side can improve circulation and is recommended in later pregnancy.',
      ],
    },
    {
      'keywords': ['stress', 'anxiety', 'worry', 'mental health'],
      'responses': [
        'Pregnancy can bring about various emotions. It\'s normal to feel anxious or stressed at times.',
        'Practice relaxation techniques like deep breathing, meditation, or gentle yoga.',
        'Don\'t hesitate to seek support from family, friends, or a mental health professional if needed.',
        'Self-care activities like reading, listening to music, or taking warm baths can help manage stress.',
      ],
    },
  ];

  static String getResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Check for greetings
    if (_isGreeting(lowerMessage)) {
      return 'Hello! 👋 I\'m your AI health assistant. I can help answer questions about pregnancy, menstrual health, nutrition, exercise, and more. What would you like to know?';
    }

    // Check for thanks/gratitude
    if (_isThanks(lowerMessage)) {
      return 'You\'re welcome! 😊 Feel free to ask me anything else about your health and wellness.';
    }

    // Find matching knowledge base entry
    int bestMatch = -1;
    int maxMatches = 0;

    for (int i = 0; i < _knowledgeBase.length; i++) {
      final keywords = _knowledgeBase[i]['keywords'] as List<String>;
      int matches = 0;
      
      for (var keyword in keywords) {
        if (lowerMessage.contains(keyword)) {
          matches++;
        }
      }
      
      if (matches > maxMatches) {
        maxMatches = matches;
        bestMatch = i;
      }
    }

    if (bestMatch >= 0 && maxMatches > 0) {
      final responses = _knowledgeBase[bestMatch]['responses'] as List<String>;
      final random = Random();
      return responses[random.nextInt(responses.length)];
    }

    // Default response
    return 'I understand you\'re asking about "$userMessage". While I can provide general health information, I recommend consulting with your healthcare provider for personalized medical advice. Is there something specific about pregnancy health, nutrition, or exercise I can help with?';
  }

  static bool _isGreeting(String message) {
    final greetings = ['hello', 'hi', 'hey', 'good morning', 'good afternoon', 'good evening'];
    return greetings.any((greeting) => message.contains(greeting));
  }

  static bool _isThanks(String message) {
    final thanks = ['thank', 'thanks', 'appreciate', 'grateful'];
    return thanks.any((word) => message.contains(word));
  }

  /// Get quick health tips
  static List<String> getQuickTips() {
    return [
      '💧 Stay hydrated - aim for 8-10 glasses of water daily',
      '🥗 Eat a variety of colorful fruits and vegetables',
      '🚶 Take regular gentle walks to boost circulation',
      '😴 Prioritize rest and sleep - your body needs it!',
      '🧘 Practice relaxation techniques to manage stress',
      '📅 Keep track of your appointments and symptoms',
      '💊 Don\'t forget your prenatal vitamins',
      '🤝 Reach out to your support network when needed',
    ];
  }
}

