// ignore_for_file: unused_element

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rnd/src/view/unFoldToExpand/onlyfoldatble/ticket_tile.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {

  final ScrollController _scrollController = ScrollController();

  final List<int> _openTickets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(direction: Axis.vertical, children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return TicketTile(
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
    double openTicketsOffset = TicketTile.nominalOpenHeight * _getOpenTicketsBefore(clickedTicket);
    double closedTicketsOffset = TicketTile.nominalClosedHeight * (clickedTicket - _getOpenTicketsBefore(clickedTicket));

    double offset = openTicketsOffset + closedTicketsOffset - (TicketTile.nominalClosedHeight * 1.9);

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
}