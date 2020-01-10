import 'package:meta/meta.dart';
import 'package:gomotive/auth/auth_state.dart';
import 'package:gomotive/client/client_state.dart';
import 'package:gomotive/user/user_state.dart';
import 'package:gomotive/news/news_state.dart';
import 'package:gomotive/message/message_state.dart';
import 'package:gomotive/practitioner/practitioner_state.dart';
import 'package:gomotive/exercise/exercise_state.dart';
import 'package:gomotive/workout/workout_state.dart';
import 'package:gomotive/conversation/conversation_state.dart';
import 'package:gomotive/scheduler/scheduler_state.dart';
import 'package:gomotive/education/education_state.dart';
import 'package:gomotive/dhf/dhf_state.dart';
import 'package:gomotive/habit/habit_state.dart';
import 'package:gomotive/gameplan/gameplan_state.dart';
import 'package:gomotive/goal/goal_state.dart';
import 'package:gomotive/document/document_state.dart';
import 'package:gomotive/intake/intake_state.dart';

@immutable
class AppState {
  final AuthState authState;
  final ClientState clientState;
  final UserState userState;
  final NewsState newsState;
  final MessageState messageState;
  final PractitionerState practitionerState;
  final ExerciseState exerciseState;
  final WorkoutState workoutState;
  final ConversationState conversationState;
  final SchedulerState schedulerState;
  final EducationState educationState;
  final DHFState dhfState;
  final HabitState habitState;
  final GameplanState gameplanState;
  final GoalState goalState;
  final DocumentState documentState;
  final IntakeState intakeState;
  
  AppState(
    {
      AuthState authState,
      ClientState clientState,
      UserState userState,
      NewsState newsState,
      MessageState messageState,
      PractitionerState practitionerState,
      ExerciseState exerciseState,
      WorkoutState workoutState,
      ConversationState converstationState,
      SchedulerState schedulerState,
      EducationState educationState,
      DHFState dhfState,
      HabitState habitState,
      GameplanState gameplanState,
      GoalState goalState,
      DocumentState documentState,
      IntakeState intakeState,
    }
  )
    : authState = authState ?? new AuthState(),
      clientState = clientState ?? new ClientState(),
      userState = userState ?? new UserState(),
      newsState = newsState ?? new NewsState(),
      messageState = messageState ?? new MessageState(),
      practitionerState = practitionerState ?? new PractitionerState(),
      exerciseState = exerciseState ?? new ExerciseState(),
      workoutState = workoutState ?? new WorkoutState(),
      conversationState =converstationState ?? new ConversationState(),
      schedulerState =schedulerState ?? new SchedulerState(),
      educationState = educationState ?? new EducationState(),
      dhfState = dhfState ?? new DHFState(),
      habitState = habitState ?? new HabitState(),
      gameplanState = gameplanState ?? new GameplanState(),
      goalState = goalState ?? new GoalState(),
      documentState = documentState ?? new DocumentState(),
      intakeState = intakeState ?? new IntakeState();

  AppState copyWith(
    {
      AuthState authState,
      ClientState clientState,
      UserState userState,
      NewsState newsState,
      MessageState messageState,
      PractitionerState practitionerState,
      ExerciseState exerciseState,
      WorkoutState workoutState,
      ConversationState converstationState,
      SchedulerState schedulerState,
      EducationState educationState,
      DHFState dhfState,
      HabitState habitState,
      GameplanState gameplanState,
      GoalState goalState,
      DocumentState documentState,
      IntakeState intakeState,
    }
  ) {
    return AppState(
      authState: authState ?? this.authState,
      clientState: clientState ?? this.clientState,
      userState: userState ?? this.userState,
      newsState: newsState ?? this.newsState,
      messageState: messageState ?? this.messageState,
      practitionerState: practitionerState ?? this.practitionerState,
      exerciseState: exerciseState ?? this.exerciseState, 
      workoutState: workoutState ?? this.workoutState,
      converstationState: converstationState ?? this.conversationState,
      schedulerState: schedulerState ?? this.schedulerState,
      educationState: educationState ?? this.educationState,
      dhfState: dhfState ?? this.dhfState,
      habitState: habitState ?? this.habitState,
      gameplanState: gameplanState ?? this.gameplanState,
      goalState: goalState ?? this.goalState,
      documentState: documentState ?? this.documentState,
      intakeState: intakeState ?? this.intakeState,
    );
  }
}
