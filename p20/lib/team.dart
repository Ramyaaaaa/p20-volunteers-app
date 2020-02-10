import 'package:flutter/material.dart';

class Team {
  final String phoneNumber;
  final String marks, rank;
  final String teamID;
  final bool isSelected;
  final List<dynamic> members;
  final TextStyle style;

  Team({
    this.phoneNumber,
    this.teamID,
    this.members,
    this.marks,
    this.rank,
    this.style,
    this.isSelected = false,
  });

  int length() {
    return members.length;
  }

  List<dynamic> memberList(){
    return this.members;
  }
}