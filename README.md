# Lenses in Elixir

## Usage:

```elixir
import Elins
kitten = %{name: "Mr. Bigglesworth", color: %{r: 1.0, g: 1.0, b: 1.0}}
kitten |> set([:color, :b], 0.0).()
# new kitten with 0 blue
kitten |> edit([:color, :g], fn(v) -> 0.5 * v end).()
# new kitten with green halved
kitten |> editVals(%{ name: &String.upcase/1, color: %{ r: &(0.5 * &1) } }).()
# new kitten with name upcase'd and red halved
```

Beside `Map`s these work on [`Structs`](http://elixir-lang.org/getting-started/structs.html) as well (which essentially are `Map`s anyway).

This started as a minimal Elixir port of @jlouis's [erl-lenses](https://github.com/jlouis/erl-lenses), which was to be superseded by his [forge](https://github.com/jlouis/forge). Since then I've expanded on it a bit (`editVals`).
