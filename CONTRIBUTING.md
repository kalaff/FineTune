# Contributing to FineTune

Thank you for your interest in contributing to FineTune!

## Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/ronitsingh10/FineTune.git
   cd FineTune
   ```

2. Open in Xcode:
   ```bash
   open FineTune.xcodeproj
   ```

3. Set your development team in Xcode:
   - Select the FineTune target
   - Go to Signing & Capabilities
   - Select your team from the dropdown

4. Build and run (Cmd+R)

## Submitting Issues

- Check existing issues before creating a new one
- Include macOS version and steps to reproduce
- For audio issues, include which apps were playing audio

## Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Test with multiple audio sources and output devices
5. Commit your changes
6. Push to your fork and open a pull request

## Code Style

- Follow existing patterns in the codebase
- Use `@Observable` and `@MainActor` for state management
- Audio callback code must be real-time safe (no allocations, locks, or ObjC)
- Views: props first, callbacks for mutations, `@State` only for local UI state

### UI Components (macOS Tahoe Liquid Glass)

The app uses a Liquid Glass design language inspired by macOS Tahoe. When contributing UI changes:

- **Floating Capsule** — Use continuous corner radius (`style: .continuous`) for rounded rectangles
- **Refraction & Specularity** — Apply `.ultraThinMaterial` with semi-transparent white gradient overlays for glass effects
- **Double-Layer Border** — 0.5pt inner white highlight (`strokeBorder`) with dynamic outer shadows
- **Hover Fluidity** — Implement parallax offset animations (`isHovered ? 1.0 : 0`) with spring animations (response: 0.4, dampingFraction: 0.6)
- Use existing view modifiers: `.hoverableRow()`, `.glassButtonStyle()`, `.vibrancyIcon()`

## Audio Callback Guidelines

Code running in `processAudio()` must be real-time safe:

- No memory allocations (`malloc`, `new`, `Array.append`)
- No locks (`NSLock`, `DispatchSemaphore`, `os_unfair_lock`)
- No Objective-C messaging
- No file I/O or logging
- No Swift `print()` statements

## Testing

Before submitting:
- Test with 2+ output devices
- Test device hot-plug (disconnect during playback)
- Test with 5+ apps playing audio simultaneously
