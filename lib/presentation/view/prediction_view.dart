import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_bump/presentation/viewmodel/risk_detector_viewmodel.dart';
import 'package:safe_bump/presentation/widgets/custom_button.dart';
import 'package:safe_bump/presentation/widgets/safe_bump_app_bar.dart';
import 'package:sizer/sizer.dart';

class PredictionView extends StatefulWidget {
  const PredictionView({Key? key}) : super(key: key);

  @override
  State<PredictionView> createState() => _PredictionViewState();
}

class _PredictionViewState extends State<PredictionView>
    with SingleTickerProviderStateMixin {
  final ageController = TextEditingController();
  final SBPcontroller = TextEditingController();
  final DBPcontroller = TextEditingController();
  final BScontroller = TextEditingController();
  final tempController = TextEditingController();
  final heartRateController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    ageController.dispose();
    SBPcontroller.dispose();
    DBPcontroller.dispose();
    BScontroller.dispose();
    tempController.dispose();
    heartRateController.dispose();
    super.dispose();
  }

  var authTextFieldDecoration = InputDecoration(
    labelStyle: TextStyle(fontSize: 10.sp, color: Colors.black87),
    errorStyle: TextStyle(fontSize: 9.sp),
    hintStyle: TextStyle(fontSize: 10.sp, color: Colors.grey.shade500),
    contentPadding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.red.shade300),
    ),
  );

  Color _getRiskColor(String? riskData) {
    if (riskData == null || riskData.isEmpty) return Colors.transparent;
    if (riskData.contains('🔴') || riskData.toLowerCase().contains('critical')) {
      return Colors.red.shade50;
    } else if (riskData.contains('🟠') || riskData.toLowerCase().contains('high')) {
      return Colors.orange.shade50;
    } else if (riskData.contains('🟡') || riskData.toLowerCase().contains('moderate')) {
      return Colors.yellow.shade50;
    } else if (riskData.contains('🟢') || riskData.toLowerCase().contains('low')) {
      return Colors.green.shade50;
    }
    return Colors.blue.shade50;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RiskDetectorViewModel>(
      builder: (context, riskDetectorViewModel, _) => Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: SafeBumpAppBar(
          title: 'AI Health Prediction',
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Form(
                key: formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 2.h),
                    // Header Card
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pink.shade100, Colors.purple.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.shade200.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            size: 40.sp,
                            color: Colors.pink.shade700,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "AI-Powered Health Assessment",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            "Enter your health metrics for instant AI analysis",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.pink.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // Input Fields
                    _buildInputField(
                      controller: ageController,
                      label: "Age",
                      hint: "Enter your age in years",
                      icon: Icons.person_outline,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildInputField(
                      controller: SBPcontroller,
                      label: "Systolic Blood Pressure",
                      hint: "mmHg (e.g., 120)",
                      icon: Icons.favorite_outline,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildInputField(
                      controller: DBPcontroller,
                      label: "Diastolic Blood Pressure",
                      hint: "mmHg (e.g., 80)",
                      icon: Icons.favorite_outline,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildInputField(
                      controller: tempController,
                      label: "Body Temperature",
                      hint: "Fahrenheit (e.g., 98.6)",
                      icon: Icons.thermostat_outlined,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildInputField(
                      controller: heartRateController,
                      label: "Heart Rate",
                      hint: "Beats per minute (e.g., 72)",
                      icon: Icons.favorite,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildInputField(
                      controller: BScontroller,
                      label: "Blood Sugar (BS)",
                      hint: "mg/dL (e.g., 100)",
                      icon: Icons.water_drop_outlined,
                    ),
                    SizedBox(height: 3.h),
                    // Predict Button
                    CustomButton(
                      label: riskDetectorViewModel.isLoading
                          ? "Analyzing..."
                          : "Get AI Prediction",
                      onPressed: riskDetectorViewModel.isLoading
                          ? null
                          : () {
                              if (formGlobalKey.currentState!.validate()) {
                                riskDetectorViewModel.getRiskData(
                                  int.parse(ageController.value.text),
                                  int.parse(SBPcontroller.value.text),
                                  int.parse(DBPcontroller.value.text),
                                  double.parse(BScontroller.value.text),
                                  double.parse(tempController.value.text),
                                  int.parse(heartRateController.value.text),
                                );
                              }
                            },
                      color: Colors.pinkAccent,
                    ),
                    SizedBox(height: 3.h),
                    // Results Card
                    if (riskDetectorViewModel.riskData != null &&
                        riskDetectorViewModel.riskData!.isNotEmpty)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: _getRiskColor(riskDetectorViewModel.riskData),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.pink.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.insights,
                                  color: Colors.pink.shade700,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "AI Analysis Results",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            _buildFormattedResult(
                                riskDetectorViewModel.riskData!),
                          ],
                        ),
                      ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: authTextFieldDecoration.copyWith(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.pinkAccent),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildFormattedResult(String result) {
    // Parse the result string and format it nicely
    final lines = result.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().isEmpty) {
          return SizedBox(height: 1.h);
        }
        
        if (line.contains('**') && line.contains('**')) {
          // Bold text (risk level)
          final parts = line.split('**');
          return Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  height: 1.5,
                ),
                children: parts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final text = entry.value;
                  if (index % 2 == 1) {
                    // Odd indices are bold
                    return TextSpan(
                      text: text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.pink.shade900,
                      ),
                    );
                  } else {
                    return TextSpan(text: text);
                  }
                }).toList(),
              ),
            ),
          );
        } else if (line.startsWith('⚠️') || line.startsWith('💡') || line.startsWith('✅')) {
          // Special formatted lines
          return Padding(
            padding: EdgeInsets.only(bottom: 0.8.h),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          );
        } else if (line.trim().startsWith(RegExp(r'^\d+\.'))) {
          // Numbered list items
          return Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
