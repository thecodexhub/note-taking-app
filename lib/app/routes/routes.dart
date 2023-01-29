import 'package:flutter/material.dart';
import 'package:note_taking_app/app/app.dart';
import 'package:note_taking_app/home/home.dart';
import 'package:note_taking_app/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
  }
}
