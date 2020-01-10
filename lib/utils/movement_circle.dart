import 'package:flutter/material.dart';
import 'dart:math';

class MovementCirclePainter extends CustomPainter{

  double mobilityPercentage;
  double strengthPercentage;
  double metabolicPercentage;
  double powerPercentage;
  double width = 16.0;

  MovementCirclePainter({
    this.mobilityPercentage, 
    this.strengthPercentage, 
    this.metabolicPercentage, 
    this.powerPercentage
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    Offset center  = new Offset(size.width/2, size.height/2);

    Paint mobilityLine = new Paint()
        ..color = Colors.lightBlue[100]
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
    Paint mobilityComplete = new Paint()
      ..color = Colors.lightBlue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    double mobilityRadius  = min(size.width/2,size.height/2);
    double mobilityArcAngle = 2*pi* (mobilityPercentage/100);

    Paint strengthLine = new Paint()
        ..color = Colors.lightGreen[100]
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
    Paint strengthComplete = new Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    double strengthRadius  = mobilityRadius - width;
    double strengthArcAngle = 2*pi* (strengthPercentage/100.0);

    Paint metabolicLine = new Paint()
        ..color = Colors.yellow[100]
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
    Paint metabolicComplete = new Paint()
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    double metabolicRadius  = strengthRadius - width;
    double metabolicArcAngle = 2*pi* (metabolicPercentage/100.0);

    Paint powerLine = new Paint()
        ..color = Colors.red[100]
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
    Paint powerComplete = new Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    double powerRadius  = metabolicRadius - width;
    double powerArcAngle = 2*pi* (powerPercentage/100.0);


    canvas.drawCircle(
        center,
        mobilityRadius,
        mobilityLine
    );    
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: mobilityRadius),
        -pi/2,
        mobilityArcAngle,
        false,
        mobilityComplete
    );

    canvas.drawCircle(
        center,
        strengthRadius,
        strengthLine
    );    
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: strengthRadius),
        -pi/2,
        strengthArcAngle,
        false,
        strengthComplete
    );

    canvas.drawCircle(
        center,
        metabolicRadius,
        metabolicLine
    );    
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: metabolicRadius),
        -pi/2,
        metabolicArcAngle,
        false,
        metabolicComplete
    );

    canvas.drawCircle(
        center,
        powerRadius,
        powerLine
    );    
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: powerRadius),
        -pi/2,
        powerArcAngle,
        false,
        powerComplete
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}