# Vovó em Ação

**Vovó em Ação** is an early-stage Godot project focused on a playful baby-care experience. The repository currently contains the project’s visual and audio assets, reusable `AtlasTexture` resources for care actions, and editor-time scripts that prepare action icons from a source sprite sheet.

> **Project status:** This repository is currently an asset and tooling foundation rather than a complete runnable game. It does not yet include a `project.godot` file, a main scene, gameplay scripts, or the source sprite sheet referenced by the icon-processing tools.

## Overview

The project is organized around a set of baby-care actions represented by illustrated icons. The available action resources cover feeding with a bottle, playing with a toy, putting the baby to sleep, changing a diaper, singing, and giving a pacifier. Supporting audio assets provide baby-crying and baby-giggle sounds.

The current codebase is intentionally small. Most of the implementation is represented by Godot resource files and editor utilities that slice a 1920 × 1920 action-icon sheet into reusable regions. A future gameplay layer can use these resources to build the user interface and connect each action to animations, sound effects, scoring, or state changes.

## Current Features

| Area | Current contents |
| --- | --- |
| Action resources | Six `AtlasTexture` resources for bottle, toy, pacifier, diaper, singing, and lullaby actions |
| Audio | Baby crying and baby giggling MP3 files |
| Artwork | Pacifier icon assets in PNG and JPEG formats, plus the repository icon |
| Editor tooling | Godot `@tool` scripts for cropping action icons and inspecting sprite bounds |
| Android artifacts | Generated Android resource and remap files are present in the repository history; the source project configuration is not currently included |

## Repository Structure

```text
.
├── assets/
│   ├── sounds/
│   │   ├── baby-crying-2.mp3
│   │   └── baby-giggle-2.mp3
│   ├── sprites/
│   │   ├── atlas_brinquedo.tres
│   │   ├── atlas_cantar.tres
│   │   ├── atlas_chupeta.tres
│   │   ├── atlas_fralda.tres
│   │   ├── atlas_mamadeira.tres
│   │   ├── atlas_ninar.tres
│   │   ├── pacifier_icon.jpg
│   │   └── pacifier_icon.png
│   └── themes/
├── android/
│   └── build/                 # Generated Android build resources and remaps
├── tools/
│   ├── crop_icons.gd          # Crops the source action-icon sheet
│   └── find_bboxes.gd         # Prints approximate non-transparent bounds
├── icon.png
├── .gitignore
└── README.md
```

The `assets/themes/` directory is reserved for theme resources, although no tracked theme resource is currently present. Godot’s `.godot/` directory, imported files, build outputs, and signing keys are excluded by `.gitignore` and should not be treated as source code.

## Requirements

The project uses **Godot 4.x** syntax and resource formats. In particular, the tools extend `SceneTree`, use the `@tool` annotation, and define `AtlasTexture` resources with format 3. Install a compatible Godot 4 editor before attempting to run or extend the project.

| Requirement | Purpose |
| --- | --- |
| Godot 4.x | Open the project, execute editor tools, and author scenes and resources |
| Git | Clone the repository and manage source changes |
| Android SDK and export templates | Required only after a complete Godot project configuration and Android export setup are added |

## Getting Started

Clone the repository and open its directory in Godot:

```bash
git clone https://github.com/ofreitas/vovo_em_acao.git
cd vovo_em_acao
```

At the current repository state, Godot cannot launch a game directly because the project configuration and entry scene are not tracked. To continue development, create or restore a Godot project in this directory, then configure an application entry point and import the existing assets.

A minimal development sequence is:

1. Open the repository directory in Godot 4.x.
2. Create or restore `project.godot` and define the project name, display settings, input actions, and main scene.
3. Add a main scene and gameplay scripts that consume the resources under `assets/sprites/`.
4. Add the referenced source artwork described in the tooling section, or update the tools to 4. Add the referenced source artwork described in thRun the project from the configured main scene.

## Action Atlas Resources

Each `.tres` file defines an `AtlasTexture` that points to the same source image and exposes a rectangular region for one action. The current regions are:

| Resource | Action | Region in source sheet |
| --- | --- | --- |
| `atlas_mamadeira.tres` | Bottle feeding | `(0, 0, 640, 960)` |
| `atlas_brinquedo.tres` | Toy | `(700, 0, 520, 960)` |
| `atlas_chupeta.tres` | Pacifier | `(640, 0, 640, 960)` |
| `atlas_ninar.tres` | Lullaby / sleep | `(1200, 0, 720, 960)` |
| `atlas_fralda.tres` | Diaper change | `(0, 960, 960, 960)` |
| `atlas_cantar.tres` | Singing | `(960, 960, 960, 960)` |

The atlas resources currently reference `res://assets/sprites/action_icons.png`. That source file is not present in the tracked working tree, so the resources will need either the original sheet restored or their `atlas` references updated before they can be used successfully in a fresh Godot import.

## Editor Tools

The scripts in `tools/` are editor-time utilities and are not gameplay systems.

### `crop_icons.gd`

`crop_icons.gd` loads `res://assets/sprites/action_icons.png`, assumes a 1920 × 1920 sheet, and writes six PNG files into `assets/sprites/`. The top half is divided into three action regions, while the bottom half is divided into two larger regions. The pacifier output currently reuses the toy crop as a temporary fallback.

Once the missing source sheet and project configuration are available, the script can be executed from the Godot command line in tool mode. A typical command is:

```bash
godot --path . --editor --headless --script res://tools/crop_icons.gd
```

Because the script depends on the missing `action_icons.png` file, this command will not complete successfully until that asset is restored or the script is changed to point to an existing image.

### `find_bboxes.gd`

`find_bboxes.gd` scans the top half of the same source sheet for pixels with alpha greater than `0.1` and prints approximate bounding boxes for three icon regions. It is useful for checking the placement of artwork before creating or adjusting atlas regions.

The current file appears to be an exploratory utility and should be reviewed for indentation and formatting before execution. It also depends on the same missing `action_icons.png` source asset.

## Suggested Gameplay Architecture

The repository does not yet prescribe a gameplay architecture. A practical next step would be to separate the project into four layers:

| Layer | Responsibility | Candidate location |
| --- | --- | --- |
| Presentation | Menus, action buttons, baby visuals, animations, and feedback | `scenes/` and `ui/` |
| Game state | Baby needs, action cooldowns, progress, and win or loss conditions | `scripts/` or `game/` |
| Content | Action icons, audio, themes, and other imported resources | `assets/` |
| Authoring tools | Asset cropping, validation, and atlas-generation helpers | `tools/` |

A future action model could associate each action with an `AtlasTexture`, an audio cue, an animation, and the need it satisfies. Keeping those relationships in data resources would make it easier to add new activities without duplicating interface logic.

## Audio Assets

The audio directory contains two MP3 files:

- `baby-crying-2.mp3`, suitable for a negative or urgent feedback state.
- `baby-giggle-2.mp3`, suitable for a positive interaction or successful care action.

Before shipping, verify that the files have the required redistribution rights and that their volume levels, loop behavior, and licensing information are documented. No license metadata for the audio is currently included in the repository.

## Android Development

The repository includes generated Android resources under `android/build/`, including launcher icons, a splash icon, and Godot remap files. These files do not replace a complete Godot Android export configuration. A maintainable Android workflow should keep export settings, Gradle configuration, and signing instructions separate from generated output.

The repository also contains a `vovo_release.keystore` file in the working tree. Keystores are sensitive signing credentials and must not be committed to a public repository. The `.gitignore` excludes keystore files for future changes, but the existing file should be removed from version control and rotated if it has ever been shared or used outside a private environment.

## Development Guidelines

Keep source assets, `.tres` resources, scenes, and scripts under version control. Do not commit `.godot/` caches, imported artifacts, generated Android build output, exported packages, or signing credentials. When adding a new action, add its artwork and atlas resource, define its audio and interaction behavior, then update the documentation and any asset-validation tooling.

Before opening a pull request, confirm that the project imports without missing-resource warnings, the main scene launches from a clean checkout, all action buttons resolve their textures, and audio assets play at an appropriate level. Android exports should be tested from a configured build environment rather than from checked-in generated files.

## Known Limitations

The following limitations are visible in the current repository state:

1. There is no tracked `project.godot` file or main scene, so the project is not directly runnable as a complete Godot game.
2. `assets/sprites/action_icons.png` is referenced by all atlas resources and both tools but is not present in the tracked assets.
3. The icon-cropping utilities generate files that are not currently included in the repository.
4. The gameplay layer, user interface, input mapping, animations, and state management have not yet been implemented in the tracked source.
5. The Android directory contains generated resources, not a documented, reproducible export pipeline.
6. The repository does not currently include a license or audio attribution document.

## Contributing

Contributions are welcome once the runnable Godot project structure has been restored. Please create a focused branch, describe the motivation and implementation in the pull request, avoid committing generated or sensitive files, and test changes from a clean checkout. Changes that introduce a new action should include the corresponding resource, asset reference, and documentation update.

## License

No license file is currently included. Until a license is added by the project owner, all rights should be considered reserved and the repository should not be redistributed as an open-source project by assumption.

## References

[1]: https://godotengine.org/ "Godot Engine official website"
[2]: https://docs.godotengine.org/en/stable/classes/class_atlastexture.html "Godot AtlasTexture documentation"
[3]: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html "Godot Android export documentation"
