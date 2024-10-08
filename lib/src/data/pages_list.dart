import 'package:rnd/src/view/biometric/biometric_page.dart';
import 'package:rnd/src/view/completer/completer_example.dart';
import 'package:rnd/src/view/dropdown/dropdown_demo.dart';
import 'package:rnd/src/view/foldEffect/fold_list_page.dart';
import 'package:rnd/src/view/image_zoom/image_zoom.dart';
import 'package:rnd/src/view/sliderWithEffect/view/dego_slider_demo.dart';
import 'package:rnd/src/view/swipable_player/swipable_player_demo.dart';
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
    "page"   : const DogSliderDemo()
  },
  {
    "title" : "Image Zoom",
    "page"   : const ImageZoom()
  },
  {
    "title" : "Instagram Zoom Effect",
    "page"   : const ZoomImage()
  },
  {
    "title" : "Drop Down",
    "page"   : const DropDownDemo()
  },
  {
    "title" : "Load Using Completer",
    "page"   : const CompleterLoadPage()
  },
  {
    "title" : "Swipable Video Player",
    "page"   : const SwipableVideoPlayerDemo()
  },
];