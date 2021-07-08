import 'package:flutter/material.dart';

double screenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height -
    MediaQuery.of(context).padding.top -
    kToolbarHeight -
    kBottomNavigationBarHeight;
