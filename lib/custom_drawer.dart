import 'package:flutter/material.dart';
import 'package:guitar_app/my_drawer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key, this.child}) : super(key: key);

     static _CustomDrawerState of(BuildContext context) => context.findAncestorStateOfType<_CustomDrawerState>();
final Widget child;
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  static const double maxSlide = 255;
  static const dragRightStartVal = 60;
  static const dragLeftStartVal = maxSlide - 20;
  static bool shouldDrag = false;
  @override
  void initState() {
    
    super.initState();
    animationController =  AnimationController(vsync: this, 
    duration: Duration(milliseconds: 250));
  }
  void toggle() =>
    animationController.isDismissed?animationController.forward():animationController.reverse();
  
  
  
 void _onDragStart(DragStartDetails startDetails) {
    bool isDraggingFromLeft = animationController.isDismissed && startDetails.globalPosition.dx < dragRightStartVal;
    bool isDraggingFromRight = animationController.isCompleted && startDetails.globalPosition.dx > dragLeftStartVal;
    shouldDrag = isDraggingFromLeft || isDraggingFromRight;
  }

  void _onDragUpdate(DragUpdateDetails updateDetails) {
    if (shouldDrag == false) {
      return;
    }
    double delta = updateDetails.primaryDelta / maxSlide;
    animationController.value += delta;
  }


void close() => animationController.reverse();

  void open () => animationController.forward();
  void _onDragEnd(DragEndDetails dragEndDetails) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }

    double _kMinFlingVelocity = 365.0;
    double dragVelocity = dragEndDetails.velocity.pixelsPerSecond.dx.abs();

    if (dragVelocity >= _kMinFlingVelocity) {
      double visualVelocityInPx = dragEndDetails.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocityInPx);
    } else if (animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd:_onDragEnd ,
          child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _){
          double slide = maxSlide * animationController.value ;
          double scale = 1 - (animationController.value * 0.3 );
          return Stack(
            children: [
              MyDrawer(),
              Transform(transform: Matrix4.identity()..translate(slide)..scale(scale),
              alignment: Alignment.centerLeft,
              child: widget.child,


              )
            ],
          );
        },
      ),
    );
  }
}