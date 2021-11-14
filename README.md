[![Build](https://github.com/linoscope/CAMLBOY/actions/workflows/workflow.yml/badge.svg)](https://github.com/linoscope/CAMLBOY/actions/workflows/workflow.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# CAMLBOY

A WIP Game Boy emulator written in OCaml.

## Screenshots

<div style="display:flex">
  <img src="/screenshot/phone-ui.jpg" height="350"/>
  <img src="/screenshot/desktop-ui.png" height="350" />
</div>

![Pokemon](./screenshot/pokemon.png)
![Zelda](./screenshot/zelda.png)
![Kirby](./screenshot/kirby.png)
![Tetris](./screenshot/tetris.png)

## TODO

### Core

- [x] CPU
- [x] MMU
- [x] Timers
- [x] Interrupt controller
- [x] GPU
  - [x] Background
  - [x] Window
  - [x] DMA transfer
  - [x] Sprites
    - [x] 8x8 sprites
    - [x] 8x16 sprites
- [ ] Cartridges
  - [x] ROM_ONLY
  - [x] MBC1
  - [x] MBC3
  - [ ] MBC5
- [x] Joypad
- [ ] APU

### UI

- [x] SDL
- [ ] Browser (with js_of_ocaml)
