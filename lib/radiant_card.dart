/// Holographic trading-card widgets for Flutter.
///
/// Renders any widget as a card lit by a Phong fragment shader, so it picks up a
/// gloss highlight that moves as you tilt the device.
///
/// This package started at
/// [DevArtel/radiant_card](https://github.com/DevArtel/radiant_card), which holds
/// the original development history from 2022-2023.
library radiant_card;

export 'src/image_context_widget.dart';
export 'src/shaded_card.dart';
export 'src/shader_config.dart';
export 'src/widget_to_image_builder.dart';