# adriangalilea/homebrew-tap

Homebrew recipes for my apps and CLI tools, all in one tap.

```
brew install --cask adriangalilea/tap/awake
brew install adriangalilea/tap/trash
```

| Cask | |
|---|---|
| [awake](https://github.com/adriangalilea/awake) | Close the lid. Your Mac stays awake |
| [chill](https://github.com/adriangalilea/chill) | Fan control with Apple in charge by default |

| Formula | |
|---|---|
| [trash](https://github.com/adriangalilea/trash) | macOS Trash CLI with a real Put Back |
| [ip](https://github.com/adriangalilea/ip) | Your local, gateway and external IP |

Each recipe here is the source of truth for its own shape; a release rewrites only its version and checksums, never by hand:

- Casks: the app's `mise run release` ([swift-utils](https://github.com/adriangalilea/swift-utils) `ship --cask`) after publishing the notarized dmg.
- Formulas: the tool's tag, through `tap.yml` in [adriangalilea/ci](https://github.com/adriangalilea/ci), which points the formula at the tag's source tarball. A formula with a bottle (trash) is still bumped by hand.

A new tool gets its recipe here, never a `homebrew-<tool>` tap of its own.
