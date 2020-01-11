
import 'package:gomotive/homefit/home/views/dashboard.dart';
import 'package:gomotive/homefit/home/views/signin.dart';
import 'package:gomotive/homefit/home/views/track.dart';
import 'package:gomotive/homefit/home/views/plans.dart';
import 'package:gomotive/homefit/home/views/my_plan.dart';
import 'package:gomotive/homefit/home/views/splash.dart';

var homefitRoutes = { // change
  '/dashboard': (context) => Dashboard(),
  '/signin': (context) => SignIn(), //it is present in coachFit
  '/track': (context) => Track(),
  '/plans': (context) => Plans(), 
  '/my_plan': (context) => MyPlan(), 
  '/splash': (context) => Splash(), 
};
