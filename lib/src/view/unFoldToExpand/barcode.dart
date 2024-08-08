import 'package:flutter/material.dart';
import 'package:rnd/src/view/unFoldToExpand/env/env.dart';

class FlightBarcode extends StatelessWidget {
  const FlightBarcode({super.key});
  static const String _pkg = "ticket_fold";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: MaterialButton(
            child: Image.asset('images/barcode.png', package: pkg),
            onPressed: () {
            }),
      ));
}