import 'package:gomotive/practitioner/views/practitioner_home.dart';
import 'package:gomotive/practitioner/views/practitioner_clients.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/practitioner/views/practitioner_client_invite.dart';
import 'package:gomotive/practitioner/views/practitioner_profile.dart';
import 'package:gomotive/practitioner/views/practitioner_exercises.dart';
import 'package:gomotive/practitioner/views/practitioner_client_filter.dart';
import 'package:gomotive/practitioner/views/practitioner_alerts.dart';
import 'package:gomotive/education/views/education_partners.dart';
import 'package:gomotive/practitioner/views/practitioner_email_all_clients.dart';

var practitionerRoutes = {
	'/practitioner/home': (context) => PractitionerHome(),
  '/practitioner/education': (context) => EducationPartners(),
  '/practitioner/clients': (context) => PractitionerClients(),
  '/practitioner/client/home': (context) => PractitionerClientHome(),
  '/practitioner/client/invite': (context) => PractitionerClientInvite(),
  '/practitioner/profile': (context) => PractitionerProfile(),
  '/practitioner/exercises': (context) => PractitionerExercises(),
  '/practitioner/clients/filter': (context) => PractitionerClientFilter(),
  '/practitioner/alerts': (context) => PractitionerAlerts(),
  '/practitioner/email_all_clients': (context) => PractitionerEmailAllClients(),
};
