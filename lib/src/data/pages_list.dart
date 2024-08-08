import 'package:rnd/src/view/biometric/biometric_page.dart';
import 'package:rnd/src/view/foldEffect/fold_list_page.dart';
import 'package:rnd/src/view/zoom_image/zoom_image.dart';

var pageList = [
  {
    "title" : "Biometric",
    "page"   : const BiometricsPage()
  },
  {
    "title" : "Fold Effects",
    "page"   : const FoldListPage()
  },
  {
    "title" : "Slider With Effects",
    "page"   : const FoldListPage()
  },
  {
    "title" : "Instagram Zoom Effect",
    "page"   : const ZoomImage()
  },
];