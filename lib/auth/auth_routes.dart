import 'package:gomotive/auth/views/signin.dart';
import 'package:gomotive/auth/views/signup.dart';
import 'package:gomotive/auth/views/forgot_password.dart';

var authRoutes = {
	'/auth/signin': (context) => SignIn(),
	'/auth/signup': (context) => SignUp(),
  '/auth/forgot_password': (context) => ForgotPassword(),
};
