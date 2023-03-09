import 'package:flutter/material.dart';

getHeight({required BuildContext context}) {
  return MediaQuery.of(context).size.height;
}

getWidth({required BuildContext context}) {
  return MediaQuery.of(context).size.width;
}
