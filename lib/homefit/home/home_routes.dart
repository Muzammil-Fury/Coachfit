
import 'package:homefit/home/views/dashboard.dart';
import 'package:homefit/home/views/signin.dart';
import 'package:homefit/home/views/track.dart';
import 'package:homefit/home/views/plans.dart';
import 'package:homefit/home/views/my_plan.dart';
import 'package:homefit/home/views/splash.dart';

var homeRoutes = { // change
  '/dashboard': (context) => Dashboard(),
  '/signin': (context) => SignIn(), //it is present in coachFit
  '/track': (context) => Track(),
  '/plans': (context) => Plans(), 
  '/my_plan': (context) => MyPlan(), 
  '/splash': (context) => Splash(), 
};
