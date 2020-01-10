import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class PractitionerState {
  final int unreadMessageCount;
  final List<Map> unreadChats;
  final int alertCount;
  final List<Map> menuItems;
  final List<Map> clients;
  final Map paginateInfo;
  final int groupCount;
  final bool supportMultipleGameplan;
  final bool isWorkfitPractice;
  final Map activeClientEngagement;  
  final Map metricSettings;
  final Map clientObj;
  final List<Map> clientFilterSelectionList;
  final List<Map> practitionerList;
  final List<Map> consultantList;
  final String clientSearchPreference;

  const PractitionerState({
    this.unreadMessageCount,
    this.unreadChats,    
    this.alertCount,
    this.menuItems,
    this.clients,
    this.paginateInfo,
    this.groupCount,
    this.supportMultipleGameplan,
    this.isWorkfitPractice,
    this.activeClientEngagement,
    this.metricSettings,
    this.clientObj,
    this.clientFilterSelectionList,
    this.practitionerList,
    this.consultantList,
    this.clientSearchPreference,
  });

  PractitionerState copyWith({
    int unreadMessageCount,
    List<Map> unreadChats,
    int alertCount,
    List<Map> menuItems,
    List<Map> clients,
    Map paginateInfo,
    int groupCount,
    bool supportMultipleGameplan,
    bool isWorkfitPractice,
    Map activeClientEngagement,
    Map metricSettings,
    Map clientObj,
    List<Map> clientFilterSelectionList,
    List<Map> practitionerList,
    List<Map> consultantList,
    String clientSearchPreference,
  }) {
    return new PractitionerState(
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      unreadChats: unreadChats ?? this.unreadChats,
      alertCount: alertCount ?? this.alertCount,
      menuItems: menuItems ?? this.menuItems,
      clients: clients ?? this.clients,
      paginateInfo: paginateInfo ?? this.paginateInfo,
      groupCount: groupCount ?? this.groupCount,
      supportMultipleGameplan: supportMultipleGameplan ?? this.supportMultipleGameplan,
      isWorkfitPractice: isWorkfitPractice ?? this.isWorkfitPractice,
      activeClientEngagement: activeClientEngagement ?? this.activeClientEngagement,
      metricSettings: metricSettings ?? this.metricSettings,
      clientObj: clientObj ?? this.clientObj,
      clientFilterSelectionList: clientFilterSelectionList ?? this.clientFilterSelectionList,
      practitionerList: practitionerList ?? this.practitionerList,
      consultantList: consultantList ?? this.consultantList,
      clientSearchPreference: clientSearchPreference ?? this.clientSearchPreference, 
    );
  }
}
