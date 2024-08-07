import 'package:rnd/src/view/biometric/biometric_page.dart';
import 'package:rnd/src/view/meatball/meatball_page.dart';
import 'package:rnd/src/view/zoom_image/zoom_image.dart';

var pageList = [
  {
    "title" : "Biometric",
    "page"   : const BiometricPage()
  },
  {
    "title" : "MeatBall Effect",
    "page"   : const MeatballPage()
  },
  {
    "title" : "Instagram Zoom Effect",
    "page"   : const ZoomImage()
  },
];