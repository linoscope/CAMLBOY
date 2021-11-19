[![Build](https://github.com/linoscope/CAMLBOY/actions/workflows/workflow.yml/badge.svg)](https://github.com/linoscope/CAMLBOY/actions/workflows/workflow.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# **_CAMLBOY_**

**_CAMLBOY_** is a Game Boy emulator that runs in the browser, written in OCaml and compiled to JS via js_of_ocaml.

Try it out in our **[demo page](https://linoscope.github.io/CAMLBOY/)**!

## Screenshots

<div align="center">
  <img src="/screenshot/pokemon-aka.gif" height="500"/>
</div>

<div align="center">
  <img src="/screenshot/pokemon-opening.gif"/>
  <img src="/screenshot/zelda-opening.gif"/>
  <img src="/screenshot/kirby-opening.gif"/>
  <img src="/screenshot/tetris-opening.gif"/>
</div>

## Project goals and non-goals

### Goals

- Playable in the browser of your phone
- Readable/maintainable code that follow OCaml's best practices

### Non-goals

- Run all games with high accuracy
- Optimize performance to the limit

## Current state

- Runs with "playable" FPS in middle-tier mobile devices
  - Around 40~60FPS in my Galaxy S9, a smartphone released in 2018
- Supports MBC1 and MCB3 cartridges
- Some visual glitches exist here and there
- Passes various test roms such as Blargg's `cpu_instrs.gb`and `instr_timing.gb`
  - [tests for Blargg's test roms](https://github.com/linoscope/CAMLBOY/blob/main/test/rom_tests/test_blargg_test_roms.ml)
  - [tests for Mooneye's test roms](https://github.com/linoscope/CAMLBOY/tree/main/test/rom_tests/mooneye)

## TODO

- [ ] Cartridge based save
- [ ] Audio Processing Unit (APU)
- [ ] Rescript backend
- [ ] Bench marks (compare default, flambda, js_of_ocaml, Rescript, ...)
- [ ] MBC5
- [ ] Game Boy Color mode

## How to run

We support both js_of_ocaml frontend for the web browser and SDL2 frontend for native desktop.

### Common steps for js_of_ocaml and SDL2

Install dependencies

```sh
opam install . --deps-only --with-test
```

### How to run js_of_ocaml frontend

- Build

```sh
  dune build

```

- Serve `_build/default/bin/web` using some server. For example, run the following with python:

```sh
python -m http.server 8000 --directory _build/default/bin/web

```

- Open `localhost:8000` in the browser

### How to run SDL2 frontend

```sh
dune exec bin/sdl2/main.exe -- <path_to_rom>

```

For example:

```sh
dune exec bin/sdl2/main.exe -- resource/games/the-bouncing-ball.gb
```

## How to run tests

### Run all tests:

```sh
dune runtest
```

### Run unit tests only:

```sh
dune runtest test/unit_tests/
```

### Run integration tests (i.e. tests that use test roms):

```sh
dune runtest test/rom_tests/
```

## Project Structure

- `lib` - Main emulator code
- `bin` - UI code
  - `web` - Web
  - `sdl2` - SDL2
- `test`
  - `unit_tests` - Unit tests
  - `rom_tests` - Integration tests that use test roms
- `resource`
  - `games` - Game roms
  - `test_roms` - Test roms used in `rom_tests`

## Resources

- [Pandocs](https://gbdev.io/pandocs/)
- [Game Boy CPU Manual](http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf)
- [gbops](https://izik1.github.io/gbops/)
- [GBEDG](https://hacktixme.ga/GBEDG/)
- [Imran Nazar's blog](https://imrannazar.com/GameBoy-Emulation-in-JavaScript)
- [codeslinger.co.uk](http://www.codeslinger.co.uk/pages/projects/gameboy.html)

## Source of game ROMs:

- [The Bouncing Ball](https://gamejolt.com/games/the-bouncing-ball-gb/86699)
- [Tobu Tobu Girl](https://tangramgames.dk/tobutobugirl/)
- [Retroid](https://the-green-screen.com/292-2/#welcome)
- [Into The Blue](https://the-green-screen.com/278-2/#welcome)
- [Wishing Sarah](https://asteristic.itch.io/wishing-sarah)
- [Rocket Man Demo](https://lightgamesgb.com/portfolio/rocket-man/)
- [SHEET IT UP](https://drludos.itch.io/sheep-it-up)
- [Cavern](https://thegreatgallus.itch.io/cavern-mvm-9)
