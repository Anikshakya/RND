import 'package:rnd/src/view/biometric/biometric_page.dart';
import 'package:rnd/src/view/unFoldToExpand/onlyfoldatble/ticket_list_page.dart';
import 'package:rnd/src/view/zoom_image/zoom_image.dart';

var pageList = [
  {
    "title" : "Biometric",
    "page"   : const BiometricsPage()
  },
  {
    "title" : "Fold Effects",
    "page"   : const TicketListPage()
  },
  {
    "title" : "Instagram Zoom Effect",
    "page"   : const ZoomImage()
  },
];