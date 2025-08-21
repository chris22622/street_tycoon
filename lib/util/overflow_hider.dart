import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Ultra-aggressive overflow suppression widget that prevents ANY overflow banners
class OverflowHider extends StatelessWidget {
  final Widget child;
  
  const OverflowHider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OverflowBox(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: ClipRect(
                child: OverflowBox(
                  maxWidth: constraints.maxWidth,
                  maxHeight: double.infinity,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom render object that completely suppresses overflow painting
class RenderOverflowSuppressor extends RenderProxyBox {
  RenderOverflowSuppressor({RenderBox? child}) : super(child);

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      // Paint the child but suppress any overflow indicators
      context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        (context, offset) {
          super.paint(context, offset);
        },
      );
    }
  }

  @override
  void performLayout() {
    if (child != null) {
      // Give the child the constraints but don't let it overflow
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.smallest;
    }
  }
}

/// Widget that uses the custom render object
class OverflowSuppressor extends SingleChildRenderObjectWidget {
  const OverflowSuppressor({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderOverflowSuppressor createRenderObject(BuildContext context) {
    return RenderOverflowSuppressor();
  }
}
