# Modular OpenSCAD rabbit house

## How to use

1. Open `main.scad` in OpenSCAD.
2. Keep all files in the same folder structure.
3. To change size, open `config.scad` and change:

```scad
preset = "8x4";
```

Supported presets:

- `"6x3"`
- `"7x3"`
- `"8x4"`

## Notes

- `main.scad` is the only file you need to open.
- OpenSCAD supports `include <...>` across multiple files, so this works even though there is no “project file” UI.
- You can also keep everything in one folder and still use the includes exactly like this.
- The 8x4 version is the most comfortable for seating + rabbit area.

## File overview

- `presets.scad` = preset dimensions
- `config.scad` = active preset and shared variables
- `helpers/` = reusable building blocks
- `modules/` = house sections
