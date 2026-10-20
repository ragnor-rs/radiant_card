## Unreleased

- Fix `WidgetToImageBuilder` crashing when the `MediaQuery` changes — resizing a desktop window
  re-ran `didChangeDependencies` and re-assigned a `late final`, throwing mid-build
- Capture the offstage widget in a post-frame callback instead of during the ticker, and skip
  frames where the boundary has not repainted yet
- Dispose the animation controller before `super.dispose()` and close the image stream
- Raise the example's SDK floor so `marquee` resolves to a version that compiles on current Flutter
- Correct the docs: tilt comes from a drag gesture, not device sensors; macOS is supported
- Drop the stale `Makefile`, whose shader-compile target wrote to a path that no longer exists

## 0.1.2

- Document the public API in the README and add contributing guidelines
- Describe the package properly in `pubspec.yaml`; add `issue_tracker` and `topics`
- Make the example self-contained so it runs from a fresh clone

## 0.1.1

- Add animation support too WidgetToImageBuilder

## 0.1.0

- Initial release