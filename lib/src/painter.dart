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
    for (int i = 0; i < stack.segments.length; i++) {
      segmentPaint.color = stack.segments[i].color;
      segmentPaint.strokeWidth = strokeWidth == 0 ? stack.width : strokeWidth;

      print('Index: $i - Sweep Angle: ${stack.segments[i].sweepAngle}');

      canvas.drawArc(
        new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: stack.radius,
        ),
        stack.startAngle * _kRadiansPerDegree,
        stack.segments[i].sweepAngle * _kRadiansPerDegree,
        chart.chartType == CircularChartType.Pie,
        segmentPaint,
      );

      // Get index
      int index =
          stack.segments.indexWhere((segment) => segment.sweepAngle > 1);

      print(index);

      if (i == stack.segments.length - 1) {
        segmentPaint.color = stack.segments[index].color;

        canvas.drawArc(
          new Rect.fromCircle(
            center: new Offset(size.width / 2, size.height / 2),
            radius: stack.radius,
          ),
          stack.startAngle * _kRadiansPerDegree,
          0.1 * _kRadiansPerDegree,
          chart.chartType == CircularChartType.Pie,
          segmentPaint,
        );
      }
    }
  }
}
