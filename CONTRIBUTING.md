# Contributing

Thanks for taking an interest in `radiant_card`.

## Reporting bugs

Open an issue at https://github.com/ragnor-rs/radiant_card/issues. Shader behaviour is very
platform-dependent, so please include:

- the output of `flutter doctor -v`;
- the device and OS version, and whether Impeller is enabled;
- a screenshot or recording, if the problem is visual.

## Development setup

```sh
flutter pub get
cd example && flutter pub get && flutter run
```

The example app is the main way to exercise the package. Shaders do not work on Flutter web, so
run it on Android, iOS or macOS — `flutter run -d macos` is the quickest loop.

The `shaders/phong.glsl` fragment program is compiled by Flutter at build time via the `shaders:`
section of `pubspec.yaml` — there is no separate compile step.

## Pull requests

- Run `flutter analyze` and make sure it is clean.
- Keep public API changes documented with `///` comments.
- Add a `CHANGELOG.md` entry under an `## Unreleased` heading.
