import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/src/animated_circular_chart.dart';
import 'package:flutter_circular_chart/src/circular_chart.dart';
import 'package:flutter_circular_chart/src/stack.dart';

class AnimatedCircularChartPainter extends CustomPainter {
  AnimatedCircularChartPainter(
      this.animation, this.labelPainter, this.strokeWidth)
      : super(repaint: animation);

  final Animation<CircularChart> animation;
  final TextPainter labelPainter;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    _paintLabel(canvas, size, labelPainter);
    _paintChart(canvas, size, animation.value, strokeWidth: strokeWidth);
  }

  @override
  bool shouldRepaint(AnimatedCircularChartPainter old) => false;
}

class CircularChartPainter extends CustomPainter {
  CircularChartPainter(this.chart, this.labelPainter);

  final CircularChart chart;
  final TextPainter labelPainter;

  @override
  void paint(Canvas canvas, Size size) {
    _paintLabel(canvas, size, labelPainter);
    _paintChart(canvas, size, chart);
  }

  @override
  bool shouldRepaint(CircularChartPainter old) => false;
}

const double _kRadiansPerDegree = Math.pi / 180;

void _paintLabel(Canvas canvas, Size size, TextPainter labelPainter) {
  if (labelPainter != null) {
    labelPainter.paint(
      canvas,
      new Offset(
        size.width / 2 - labelPainter.width / 2,
        size.height / 2 - labelPainter.height / 2,
      ),
    );
  }
}

void _paintChart(Canvas canvas, Size size, CircularChart chart,
    {double strokeWidth = 0}) {
  final Paint segmentPaint = new Paint()
    ..style = chart.chartType == CircularChartType.Radial
        ? PaintingStyle.stroke
        : PaintingStyle.fill
    ..strokeCap = chart.edgeStyle == SegmentEdgeStyle.round
        ? StrokeCap.round
        : StrokeCap.butt;

  for (final CircularChartStack stack in chart.stacks) {
    for (final segment in stack.segments) {
      segmentPaint.color = segment.color;
      segmentPaint.strokeWidth = strokeWidth == 0 ? stack.width : strokeWidth;

      canvas.drawArc(
        new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: stack.radius,
        ),
        stack.startAngle * _kRadiansPerDegree,
        segment.sweepAngle * _kRadiansPerDegree,
        chart.chartType == CircularChartType.Pie,
        segmentPaint,
      );
    }
  }
}
