# Benchmark

## Environment

- CPU: `Intel(R) Core(TM) i7-8665U CPU @ 1.90GHz`
- OS: `Ubuntu 20.04.2`
- Browser: `Google Chrome Version 95.0.4638.69`

## Command

### OCaml 4.13.1

```sh
opam switch 4.13.1
eval $(opam env)
dune build --profile=release
dune exec bin/sdl2/bench.exe -- resource/games/tobu.gb --frames 1500

```

### OCaml 4.13.1 + Flambda

```sh
opam switch 4.13.1+flambda
eval $(opam env)
dune build --profile=release
dune exec bin/sdl2/bench.exe -- resource/games/tobu.gb --frames 1500

```

### js_of_ocaml 3.11.0

```sh
opam switch 4.13.1
eval $(opam env) && dune build
python -m http.server 8000 --directory _build/default/bin/web
xdg-open http://localhost:8000/bench.html?frames=1500&rom_path=./tobu.gb

```
