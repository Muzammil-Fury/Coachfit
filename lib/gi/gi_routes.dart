import 'package:gomotive/gi/views/gi_3dmaps.dart';
import 'package:gomotive/gi/views/gi_golf.dart';
import 'package:gomotive/gi/views/gi_3dmaps_assessment.dart';

var giRoutes = {
	'/gi/3dmaps': (context) => GI3dmaps(),
  '/gi/golf': (context) => GIGolf(),
  '/gi/3dmaps/assessment': (context) => GI3dmapsAssessment(),
};
