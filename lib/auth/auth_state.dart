import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class AuthState {

  final Map user;
  final Map businessPartner;
  final List<Map> roles;

  const AuthState({
    this.user,
    this.businessPartner,
    this.roles
  });

  AuthState copyWith({
    Map user,
    Map businessPartner,
    List<Map> roles
  }) {
    return new AuthState(
      user: user ?? this.user,
      businessPartner: businessPartner ?? this.businessPartner,
      roles: roles ?? this.roles
    );
  }
}
