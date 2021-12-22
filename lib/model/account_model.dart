import 'package:flutter/material.dart';

class AccountModel {
  final String accName;
  final String validThru;
  final bool transfer;
  final String accOwner;
  final String accNumber;
  final String balance;
  final Color bgColor;
  final Color fontColor;

  AccountModel(
    this.accName,
    this.validThru,
    this.transfer,
    this.accOwner,
    this.accNumber,
    this.balance,
    this.bgColor,
    this.fontColor,
  );
}
