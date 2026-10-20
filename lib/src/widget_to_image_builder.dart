import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WidgetToImageBuilder extends StatefulWidget {
  final Widget child;
  final Function(BuildContext, ui.Image?) builder;

  const WidgetToImageBuilder({
    super.key,
    required this.child,
    required this.builder,
  });

  @override
  State<WidgetToImageBuilder> createState() => _WidgetToImageBuilderState();
}

class _WidgetToImageBuilderState extends State<WidgetToImageBuilder> with SingleTickerProviderStateMixin<WidgetToImageBuilder> {
  final _offstageKey = GlobalKey();

  final StreamController<ui.Image> _streamController = StreamController.broadcast();

  late final Stream<ui.Image> _imageStream = _streamController.stream;

  double _pixelRatio = 1.0;
  bool _capturePending = false;

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this)..addListener(_scheduleRepaint);
    _animationController.repeat(period: const Duration(seconds: 1));
  }

  /// Captures the offstage widget once the frame it belongs to has been painted.
  ///
  /// The ticker fires during the frame's transient callbacks, before layout and
  /// paint have run, so capturing right here would hand [ui.Image] a boundary
  /// that is still dirty. Deferring to the post-frame callback keeps the capture
  /// on a clean tree, and [_capturePending] keeps at most one in flight.
  void _scheduleRepaint() {
    if (_capturePending) {
      return;
    }
    _capturePending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _repaint());
  }

  Future<void> _repaint() async {
    try {
      final image = await _getUiImage(
        key: _offstageKey,
        pixelRatio: _pixelRatio,
      );
      if (image != null && !_streamController.isClosed) {
        _streamController.add(image);
      }
    } finally {
      _capturePending = false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Runs again every time the MediaQuery changes — resizing the window, or
    // moving it to a display of a different density — so this cannot be a
    // `late final`: re-assigning one throws mid-build and corrupts the tree.
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.passthrough,
    children: [
      Transform.translate(
        offset: const Offset(1000000, 0), // TODO must be far enough to ensure the widget is off the screen
        child: IgnorePointer(
          child: RepaintBoundary(
            key: _offstageKey,
            child: widget.child,
          ),
        ),
      ),
      StreamBuilder<ui.Image>(
        stream: _imageStream,
        builder: (context, snapshot) => widget.builder(context, snapshot.data),
      ),
    ],
  );
}

Future<ui.Image?> _getUiImage({
  required GlobalKey<State> key,
  required double pixelRatio,
}) async {
  final context = key.currentContext;
  if (context == null) {
    return null;
  }
  final boundary = context.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    return null;
  }
  // `toImage` asserts the boundary's layer is clean. A boundary that has been
  // laid out but not yet painted — the frame after a resize, say — would trip
  // that assert, so skip this capture and let the next tick pick it up.
  var needsPaint = false;
  assert(() {
    needsPaint = boundary.debugNeedsPaint;
    return true;
  }());
  if (needsPaint) {
    return null;
  }
  return boundary.toImage(pixelRatio: pixelRatio);
}
