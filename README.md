# Lenses in Elixir

## Usage:

```elixir
import Elins
# make a kitten to alter
kitten = %{name: "Mr. Bigglesworth", color: %{r: 1.0, g: 1.0, b: 1.0}}
# make a new kitten with a (deep) property set to a new value
kitten |> set([:color, :b], 0.0).()
# result: new kitten with 0 blue
# make a new kitten with a (deep) property changed
kitten |> edit([:color, :g], fn(v) -> 0.5 * v end).()
# result: new kitten with green halved
# make a new kitten with multiple properties changed
kitten |> editVals(%{ name: &String.upcase/1, color: %{ r: &(0.5 * &1) } }).()
# result: new kitten with name upcase'd and red halved
# make a new kitten with multiple properties changed through maps and lists
%{name: "Mr. Bigglesworth", children: [ %{num: 1}, %{num: 2}, %{num: 3} ] } |>
editVals(%{ name: &String.upcase/1, children: [ %{ num: &(&1 + 1) } ] }).()
# result: new kitten with name upcase'd and each child number incremented
```

Beside `Map`s these work on [`Structs`](http://elixir-lang.org/getting-started/structs.html) as well (which essentially are `Map`s anyway).

This started as a minimal Elixir port of @jlouis's [erl-lenses](https://github.com/jlouis/erl-lenses), which was to be superseded by his [forge](https://github.com/jlouis/forge). Since then I've expanded on it a bit (`editVals`).
