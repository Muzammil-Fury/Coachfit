class HomePageDetailsSuccessActionCreator {
  final Map responseData;
  HomePageDetailsSuccessActionCreator(
    this.responseData
  );
}

class PractitionerClientsSuccessActionCreator {
  final Map responseData;
  PractitionerClientsSuccessActionCreator(
    this.responseData
  );
}

class PractitionerClientHomePageSuccessActionCreator {
  final Map clientObj;
  PractitionerClientHomePageSuccessActionCreator(
    this.clientObj
  );
}

class ClearPractitionerClientHomeActionCreator {
  ClearPractitionerClientHomeActionCreator(
  );
}

class PractitionerGetEngagementSuccessActionCreator{
  final Map engagement;
  PractitionerGetEngagementSuccessActionCreator(
    this.engagement
  );
}

class PractitionerEngagementClearActionCreator{
  PractitionerEngagementClearActionCreator(
  );
}

class PractitionerClientFilterSuccessActionCreator{
  final List<Map> clientFilterSelectionList;
  final List<Map> practitionerList;
  final List<Map> consultantList;
  final String clientSearchPreference;
  PractitionerClientFilterSuccessActionCreator(
    this.clientFilterSelectionList,
    this.practitionerList,
    this.consultantList,
    this.clientSearchPreference,
  );
}

class PractitionerClientToggleVisibilitySuccessActionCreator {
  final int clientIndex;
  PractitionerClientToggleVisibilitySuccessActionCreator(
    this.clientIndex
  );
}