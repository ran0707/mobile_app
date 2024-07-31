import 'dart:ui';


class DetectedObject{
  final Rect rect;
  final String label;
  final double confidence;

  DetectedObject(this.rect, this.label, this.confidence);
}