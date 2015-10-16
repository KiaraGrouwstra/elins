# Lenses in Elixir

## Usage:

```elixir
import Elins
kitten = %{name: "Mr. Bigglesworth", color: %{r: 1.0, g: 1.0, b: 1.0}}
kitten |> set [:color, :b], 0.0
kitten |> edit [:color, :g], fn(v) -> 0.5 * v end
```

Beside Maps these work on [Structs](http://elixir-lang.org/getting-started/structs.html) as well.

This is mostly a port of @jlouis's [erl-lenses](https://github.com/jlouis/erl-lenses) (less comments, examples, proofs), which I wasn't able to compile using Mix. Apparently he's making a newer one, [forge](https://github.com/jlouis/forge).

Anyway, I'm still sorta new to Elixir and Functional Programming, hence this API is simple. Just like my needs. I'm sure performance is terrible.
