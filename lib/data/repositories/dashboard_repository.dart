import 'package:injectable/injectable.dart';
import 'package:safe_bump/domain/entities/user_model.dart';

import '../../domain/entities/pregnancy_details.dart';

@factoryMethod
abstract class DashboardRepository{
  Future<UserModel?> getUserDetails();
  Future<PregnancyDetails?> getPregnancyDetails();
}