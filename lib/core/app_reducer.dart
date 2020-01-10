import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/auth/auth_reducer.dart';
import 'package:gomotive/client/client_reducer.dart';
import 'package:gomotive/user/user_reducer.dart';
import 'package:gomotive/news/news_reducer.dart';
import 'package:gomotive/message/message_reducer.dart';
import 'package:gomotive/practitioner/practitioner_reducer.dart';
import 'package:gomotive/exercise/exercise_reducer.dart';
import 'package:gomotive/workout/workout_reducer.dart';
import 'package:gomotive/conversation/conversation_reducer.dart';
import 'package:gomotive/scheduler/scheduler_reducer.dart';
import 'package:gomotive/education/education_reducers.dart';
import 'package:gomotive/dhf/dhf_reducers.dart';
import 'package:gomotive/habit/habit_reducer.dart';
import 'package:gomotive/gameplan/gameplan_reducers.dart';
import 'package:gomotive/goal/goal_reducers.dart';
import 'package:gomotive/document/document_reducer.dart';
import 'package:gomotive/intake/intake_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    authState: authReducer(state.authState, action),
    clientState: clientReducer(state.clientState, action),
    userState: userReducer(state.userState, action),
    newsState: newsReducer(state.newsState, action),
    messageState: messageReducer(state.messageState, action),
    practitionerState: practitionerReducer(state.practitionerState, action),
    exerciseState: exerciseReducer(state.exerciseState, action),
    workoutState: workoutReducer(state.workoutState, action),
    converstationState: conversationReducer(state.conversationState, action),
    schedulerState: schedulerReducer(state.schedulerState, action),
    educationState: educationReducer(state.educationState, action),
    dhfState: dhfReducer(state.dhfState, action),
    habitState: habitReducer(state.habitState, action),
    gameplanState: gameplanReducer(state.gameplanState, action),
    goalState: goalReducer(state.goalState, action),
    documentState: documentReducer(state.documentState, action),
    intakeState: intakeReducer(state.intakeState, action),
  );
}
