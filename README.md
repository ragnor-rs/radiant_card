# radiant_card

Holographic trading-card widgets for Flutter.

`radiant_card` renders any widget as a card lit by a Phong fragment shader, so it picks up a
gloss highlight that moves as you drag across the card. A mask image controls where the card is
shiny, which is what gives foil and holo patterns their look.

## Platform support

Fragment shaders require Impeller or a Skia backend with shader support. Verified on **Android**,
**iOS** and **macOS**; **Flutter web is not supported**.

`RotatableShadedCard` takes its tilt from a drag gesture, so it behaves the same under a finger or
a mouse and needs no device sensors. To drive the tilt from something else — an animation, or a
real accelerometer — use `ShadedCard` and pass a `normal` yourself.

## Install

```yaml
dependencies:
  radiant_card: ^0.1.1
```

## Usage

A card needs two textures: the card face and a gloss mask. `ImageContextWidget` decodes asset
images into `dart:ui` images for you, and `WidgetToImageBuilder` turns a live widget — animations
included — into the card face.

```dart
import 'package:flutter/material.dart';
import 'package:radiant_card/radiant_card.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

ImageContextWidget(
  imageFiles: const ['assets/images/mask.png'],
  emptyBuilder: (context) => const SizedBox.shrink(),
  builder: (context, images) => WidgetToImageBuilder(
    child: const MyCardFace(),
    builder: (context, cardFace) => cardFace == null
        ? const SizedBox.shrink()
        : RotatableShadedCard(
            mainTexture: cardFace,
            mask: images[0],
            // Where the card sits in shader world space, and how big it is there.
            centerPos: Vector3(0, 0, 0),
            worldSize: const Size(0.5, 0.7),
          ),
  ),
);
```

`RotatableShadedCard` wires the device's orientation into the lighting. To control the tilt
yourself — a drag gesture, an animation — use `ShadedCard` and pass a `normal` directly.

Lighting is tunable through `PhongShaderConfig`:

```dart
ShadedCard(
  mainTexture: cardFace,
  mask: mask,
  normal: Vector3(0, 0, -1),
  shaderConfig: PhongShaderConfig(
    ambientCoefficient: 0,
    diffuseCoefficient: 1,
    specularCoefficient: 1,
    shininess: 80,
    ambientColor: Vector3(0, 0, 0),
    specularColor: Vector3(1, 1, 1),
  ),
  centerPos: Vector3(0, 0, 0),
  worldSize: const Size(0.5, 0.7),
);
```

## Example

A runnable demo lives in [`example/`](example):

```sh
cd example
flutter run
```

## Origin

This package started at [DevArtel/radiant_card](https://github.com/DevArtel/radiant_card), which
holds the original development history from 2022–2023.

## Contributing

Bug reports and pull requests are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © radiant_card contributors
