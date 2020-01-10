import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class UserState {

  final Map user;
  final List<Map> genderList;
  final List<Map> timezoneList;
  final Map movementMeterSettings;
  final List<Map> movementMeterWeeklyGraph;

  const UserState({
    this.user,
    this.genderList,
    this.timezoneList,
    this.movementMeterSettings,
    this.movementMeterWeeklyGraph,
  });

  UserState copyWith({
    Map user,
    List<Map> genderList,
    List<Map> timezoneList,
    Map movementMeterSettings,
    List<Map> movementMeterWeeklyGraph

  }) {
    return new UserState(
      user: user ?? this.user,
      genderList: genderList ?? this.genderList,
      timezoneList: timezoneList ?? this.timezoneList,
      movementMeterSettings: movementMeterSettings ?? this.movementMeterSettings,
      movementMeterWeeklyGraph: movementMeterWeeklyGraph ?? this.movementMeterWeeklyGraph,
    );
  }
}
