// ignore_for_file: unused_element

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rnd/src/view/foldEffect/fold_tile.dart';

class FoldListPage extends StatefulWidget {
  const FoldListPage({super.key});

  @override
  State<FoldListPage> createState() => _FoldListPageState();
}

class _FoldListPageState extends State<FoldListPage> {

  final ScrollController _scrollController = ScrollController();

  final List<int> _openTickets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Flex(direction: Axis.vertical, children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return FoldTile(
                onClick: () => _handleClickedFoldable(index),
              );
            },
          ),
        ),
      ]),
    );
  }

  bool _handleClickedFoldable(int clickedFoldIndex) {
    // Scroll to ticket position
    // Add or remove the item of the list of open tickets
    _openTickets.contains(clickedFoldIndex) ? _openTickets.remove(clickedFoldIndex) : _openTickets.add(clickedFoldIndex);

    // Calculate heights of the open and closed elements before the clicked item
    double openTicketsOffset = FoldTile.nominalOpenHeight * _getOpenTicketsBefore(clickedFoldIndex);
    double closedTicketsOffset = FoldTile.nominalClosedHeight * (clickedFoldIndex - _getOpenTicketsBefore(clickedFoldIndex));

    double offset = openTicketsOffset + closedTicketsOffset - (FoldTile.nominalClosedHeight * 1.6);

    // Scroll to the clicked element
    _scrollController.animateTo(max(0, offset),
        duration: const Duration(seconds: 1), curve: const Interval(.25, 1, curve: Curves.easeOutQuad));
    // Return true to stop the notification propagation
    return true;
  }

  _getOpenTicketsBefore(int foldableIndex) {
    // Search all indexes that are smaller to the current index in the list of indexes of open tickets
    return _openTickets.where((int index) => index < foldableIndex).length;
  }
}