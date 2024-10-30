

import 'package:flutter/material.dart';

enum ActionType{
  accountManager,
  pOD,
  myBankAccount,
  mpin,
  myEarnings,
  myReferrals,
  changeLanguage,
  joinTelegram,
  rateUs,
  aboutApp,
  tdsDeduction,
  privacyPolicy,
  termsConditions,
  logout,
  support,
  
}

class DrawerTileModel {
  String label;
  String svgIcon;
  bool onlyIcon;
  IconData icon;
  ActionType? actionType;
  Function ()? onTap;

  DrawerTileModel({
    required this.label,
    this.svgIcon = "",
    this.onTap,
    this.onlyIcon = true,
    required this.icon,
    required this.actionType
  });
}