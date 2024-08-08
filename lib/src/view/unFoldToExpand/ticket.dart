import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rnd/src/view/unFoldToExpand/barcode.dart';
import 'package:rnd/src/view/unFoldToExpand/folding_tikcet.dart';

import 'demo_data.dart';
import 'flight_details.dart';
import 'flight_summary.dart';

class Ticket extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final BoardingPassData boardingPass;
  final VoidCallback? onClick;

  const Ticket({super.key, required this.boardingPass, required this.onClick});
  @override
  State<StatefulWidget> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  FlightSummary? topCard;
  late FlightSummary frontCard = FlightSummary(boardingPass: widget.boardingPass);
  late FlightDetails middleCard = FlightDetails(widget.boardingPass);
  FlightBarcode bottomCard = const FlightBarcode();
  bool _isOpen = false;

  Widget get backCard => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: const Color(0xffdce6ef),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FoldingTicket(entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap);
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: 160.0, front: topCard),
      FoldEntry(height: 160.0, front: middleCard, back: frontCard),
      FoldEntry(height: 80.0, front: bottomCard, back: backCard)
    ];
  }

  void _handleOnTap() {
    widget.onClick?.call();
    setState(() {
      _isOpen = !_isOpen;
      topCard = FlightSummary(boardingPass: widget.boardingPass, theme: SummaryTheme.dark, isOpen: _isOpen);
    });
  }
}