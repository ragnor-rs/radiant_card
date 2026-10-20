# radiant_card example

A demo app for the [`radiant_card`](../) package. It renders a card whose face is a live widget
tree — gradient, icon and a scrolling marquee — captured to a texture and lit by the Phong
fragment shader.

## Running

```sh
flutter pub get
flutter run
```

Shaders do not work on Flutter web, so run it on Android, iOS or macOS.

## What to look for

- **Drag across the card.** The gloss highlight tracks the drag and the card tilts to match.
- **The marquee keeps scrolling** while the card is a texture, which shows that
  `WidgetToImageBuilder` captures continuously rather than taking a one-off snapshot.
- **The refresh button** rebuilds the card from scratch.
