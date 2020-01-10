class AuthLoginSuccess {
  final Map user;
  final List<Map> roles;
  AuthLoginSuccess(
    this.user,
    this.roles
  );
}

class BusinessPartnerDetailsSuccessActionCreator {
  final Map businessPartner;
  BusinessPartnerDetailsSuccessActionCreator(this.businessPartner);
}

class SaveUserProfileActionCreator {
  final Map user;
  SaveUserProfileActionCreator(
    this.user
  );
}
