import 'package:flutter/material.dart';

/// Typical phones and narrow tablets (width &lt; 1080, height &lt; 2000).
bool isCompactScreen(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width < 1080 && size.height < 2000;
}

/// One typography step smaller on compact screens (e.g. 16→14, 14→13, 12→11).
double compactOneStepSmallerFont(BuildContext context, double fontSize) {
  if (!isCompactScreen(context)) return fontSize;
  if (fontSize >= 15.5) return fontSize - 2;
  if (fontSize >= 13) return fontSize - 1;
  return fontSize - 1;
}
