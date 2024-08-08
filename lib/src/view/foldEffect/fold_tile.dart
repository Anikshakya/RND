import 'package:flutter/material.dart';
import 'package:rnd/src/view/foldEffect/fold_animation_effect.dart';



class FoldTile extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final VoidCallback? onClick;

  const FoldTile({super.key, required this.onClick});
  @override
  State<StatefulWidget> createState() => _FoldTileState();
}

class _FoldTileState extends State<FoldTile> {
  bool _isOpen = false;
  var openTop = Container(width: double.infinity, color: const Color.fromARGB(255, 203, 226, 245), child : const Center(child: Text("TOP", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300))));
  var openMid = Container(width: double.infinity, color: const Color.fromARGB(255, 235, 183, 179), child : const Center(child: Text("MIDDLE", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300))));
  var initialMid = Container(width: double.infinity, color: const Color.fromARGB(255, 233, 182, 241), child : const Center(child: Text("MID INITIAL", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300))));
  var openBottom = Container(width: double.infinity, color: const Color.fromARGB(255, 195, 248, 197), child : const Center(child: Text("BOTTOM", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300))));
  var bottomBack = Container(width: double.infinity, color: const Color.fromARGB(255, 245, 240, 199), child : const Center(child: Text("BOTTOM BACK", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300))));

  @override
  Widget build(BuildContext context) {
    return FoldingCompartment(entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap);
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: 140.0, front: openTop),
      FoldEntry(height: 140.0, front: openMid, back: initialMid),
      FoldEntry(height: 140.0, front: openBottom, back: bottomBack)
    ];
  }

  void _handleOnTap() {
    widget.onClick?.call();
    setState(() {
      _isOpen = !_isOpen;
    });
  }
}