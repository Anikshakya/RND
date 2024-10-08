import 'package:flutter/material.dart';

enum DropdownAnimation { slideDown, popUp, scale, fade }

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T?, int?)? onChanged; // Updated callback to include index
  final Widget? hint;
  final Widget? icon;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Color? dropdownColor;
  final double? elevation;
  final double? borderRadius;
  final double? maxHeight;
  final DropdownAnimation animationType; // New parameter for animation type
  final Widget? child; // New parameter for custom container

  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.value,
    this.onChanged,
    this.hint,
    this.icon,
    this.width,
    this.height,
    this.decoration,
    this.padding,
    this.dropdownColor,
    this.elevation,
    this.borderRadius,
    this.maxHeight = 200,
    this.animationType = DropdownAnimation.slideDown, // Default to slideDown
    this.child, // Initialize custom container
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scrollController = ScrollController();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _animationController.reverse().then((_) {
        _overlayEntry.remove();
        setState(() {
          _isOpen = false;
        });
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      _animationController.forward();
      setState(() {
        _isOpen = true;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    Widget dropdownContent = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight!,
      ),
      child: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return InkWell(
              onTap: () {
                widget.onChanged?.call(item, index);
                _toggleDropdown();
              },
              child: widget.itemBuilder(context, item),
            );
          },
        ),
      ),
    );

    switch (widget.animationType) {
      case DropdownAnimation.popUp:
        return OverlayEntry(
          builder: (context) => Positioned(
            width: widget.width ?? MediaQuery.of(context).size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, widget.height ?? 50),
              child: Material(
                color: widget.dropdownColor ?? Colors.white,
                elevation: widget.elevation ?? 2,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: ScaleTransition(
                    scale: _sizeAnimation,
                    child: dropdownContent,
                  ),
                ),
              ),
            ),
          ),
        );

      case DropdownAnimation.scale:
        return OverlayEntry(
          builder: (context) => Positioned(
            width: widget.width ?? MediaQuery.of(context).size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, widget.height ?? 50),
              child: Material(
                color: widget.dropdownColor ?? Colors.white,
                elevation: widget.elevation ?? 2,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                child: ScaleTransition(
                  scale: _sizeAnimation,
                  child: dropdownContent,
                ),
              ),
            ),
          ),
        );

      case DropdownAnimation.fade:
        return OverlayEntry(
          builder: (context) => Positioned(
            width: widget.width ?? MediaQuery.of(context).size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, widget.height ?? 50),
              child: Material(
                color: widget.dropdownColor ?? Colors.white,
                elevation: widget.elevation ?? 2,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: dropdownContent,
                ),
              ),
            ),
          ),
        );

      case DropdownAnimation.slideDown:
      default:
        return OverlayEntry(
          builder: (context) => Positioned(
            width: widget.width ?? MediaQuery.of(context).size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, widget.height ?? 50),
              child: Material(
                color: widget.dropdownColor ?? Colors.white,
                elevation: widget.elevation ?? 2,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                child: SizeTransition(
                  sizeFactor: _sizeAnimation,
                  axisAlignment: -1.0,
                  child: dropdownContent,
                ),
              ),
            ),
          ),
        );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: widget.child ?? Container(  // Use custom container if provided
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? 50,
          decoration: widget.decoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.value != null
                  ? widget.itemBuilder(context, widget.value as T)
                  : widget.hint ?? const Text('Select an item'),
              widget.icon ?? const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
