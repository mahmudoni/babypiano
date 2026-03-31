# Baby Piano

Baby Piano is a professionally structured Flutter + Flame game project inspired by piano tiles, but simplified for babies and toddlers. The gameplay is intentionally soft:

- big colorful targets
- slow speed ramp
- no hard fail state
- short memory loops
- persistent settings and progress

## Modes

- `Calm Tiles`: slow falling blocks with a forgiving rhythm loop
- `Free Play`: large piano pads for open-ended sound exploration
- `Memory Echo`: short note sequences for repeat-and-remember play

## Stack

- `Flutter 3.41.6`
- `Flame` for the falling-tile gameplay loop
- `flutter_riverpod` for app state
- `shared_preferences` for local persistence
- `gen_l10n` with English and Bangla string files

## Project Structure

```text
lib/
  main_dev.dart
  main_prod.dart
  src/
    app/
    core/
    features/
```

Key areas:

- `src/core`: theme, config, providers, shared constants
- `src/features/audio`: background music and low-latency note playback
- `src/features/settings`: settings model, persistence, controller, sheet UI
- `src/features/game`: game modes, Flame loop, progress repository
- `src/features/home`: landing screen and mode selection

## Environments

The app uses separate entrypoints for development and production:

- Dev: `flutter run -t lib/main_dev.dart`
- Prod: `flutter run -t lib/main_prod.dart`

`main.dart` currently forwards to the production entrypoint so default builds stay release-oriented.

## Local Setup

1. Install Flutter.
2. Run `flutter pub get`
3. Run `flutter gen-l10n`
4. Start the dev build with `flutter run -t lib/main_dev.dart`

## Verification

- `flutter analyze`
- `flutter test`

## GitHub Automation

- `CI`: runs `flutter analyze` and `flutter test` on pushes and pull requests
- `Deploy Web`: builds the Flutter web app and publishes it to GitHub Pages

If GitHub Pages is not enabled yet for the repository, do this one time:

1. Open the repository on GitHub
2. Go to `Settings > Pages`
3. Set `Source` to `GitHub Actions`

After that, every push to `master` will trigger a fresh web deployment.

## Audio

The repo includes generated local WAV assets for a zero-setup demo experience.

If you want to swap in the Pixabay lullaby later, replace the background loop at:

- `assets/audio/music/twinkle_lullaby_loop.wav`

and keep the same asset path, or update `lib/src/core/constants/app_assets.dart`.

## Notes

- Strings are maintained through ARB files in `lib/l10n/`
- The current implementation is offline-first and does not require any API keys
- Settings values are clamped to safe ranges before use
