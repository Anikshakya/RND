import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rnd/src/view/unFoldToExpand/demo_data.dart';
import 'package:rnd/src/view/unFoldToExpand/env/env.dart';
import 'package:rnd/src/view/unFoldToExpand/ticket.dart';


class TicketFoldDemo extends StatefulWidget {
  const TicketFoldDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TicketFoldDemoState createState() => _TicketFoldDemoState();
}

class _TicketFoldDemoState extends State<TicketFoldDemo> {
  final List<BoardingPassData> _boardingPasses = DemoData().boardingPasses;

  final Color _backgroundColor = const Color(0xFFf0f0f0);

  final ScrollController _scrollController = ScrollController();

  final List<int> _openTickets = [];

  static const String _pkg = "ticket_fold";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(),
      body: Flex(direction: Axis.vertical, children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: _boardingPasses.length,
            itemBuilder: (BuildContext context, int index) {
              return Ticket(
                boardingPass: _boardingPasses.elementAt(index),
                onClick: () => _handleClickedTicket(index),
              );
            },
          ),
        ),
      ]),
    );
  }

  bool _handleClickedTicket(int clickedTicket) {
    // Scroll to ticket position
    // Add or remove the item of the list of open tickets
    _openTickets.contains(clickedTicket) ? _openTickets.remove(clickedTicket) : _openTickets.add(clickedTicket);

    // Calculate heights of the open and closed elements before the clicked item
    double openTicketsOffset = Ticket.nominalOpenHeight * _getOpenTicketsBefore(clickedTicket);
    double closedTicketsOffset = Ticket.nominalClosedHeight * (clickedTicket - _getOpenTicketsBefore(clickedTicket));

    double offset = openTicketsOffset + closedTicketsOffset - (Ticket.nominalClosedHeight * .5);

    // Scroll to the clicked element
    _scrollController.animateTo(max(0, offset),
        duration: const Duration(seconds: 1), curve: const Interval(.25, 1, curve: Curves.easeOutQuad));
    // Return true to stop the notification propagation
    return true;
  }

  _getOpenTicketsBefore(int ticketIndex) {
    // Search all indexes that are smaller to the current index in the list of indexes of open tickets
    return _openTickets.where((int index) => index < ticketIndex).length;
  }

  PreferredSizeWidget _buildAppBar() {
    Color appBarIconsColor = const Color(0xFF212121);
    return AppBar(
      scrolledUnderElevation: 0,
      leading: Icon(Icons.arrow_back, color: appBarIconsColor),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Icon(Icons.more_horiz, color: appBarIconsColor, size: 28),
        )
      ],
      backgroundColor: _backgroundColor,
      elevation: 0,
      title: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text('Boarding Passes'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                letterSpacing: 0.5,
                color: appBarIconsColor,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                package: pkg)),
      ),
    );
  }
}