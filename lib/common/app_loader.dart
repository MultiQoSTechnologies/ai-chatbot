import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AppLoader {
  static void showLoader(
    BuildContext context,
  ) {
    if (!Loader.isShown) {
      Loader.show(context,
          progressIndicator: const SizedBox(
            height: 100,
            width: 100,
            child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,

                /// Required, The loading type of the widget
                colors: [Color(0xFFB09684)],

                /// Optional, The color collections
                strokeWidth: 2,

                /// Optional, The stroke of the line, only applicable to widget which contains line
                /// Optional, Background of the widget
                pathBackgroundColor: Colors.black

                /// Optional, the stroke backgroundColor
                ),
          ),
          overlayColor: Colors.black.withOpacity(0.6),
          overlayFromTop: 0);
    }
  }

  static void hideLoader() {
    Loader.hide();
  }
}
