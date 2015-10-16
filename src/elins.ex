defmodule Elins do

  def lens(n) do
    {
      fn(r) -> Map.fetch!(r, n) end,
      fn(a, r) -> Map.put(r, n, a) end
    }
  end

  def lens_id() do
    {
      fn(x) -> x end,
      fn(a, _x) -> a end
    }
  end

  def compose({lg, lp}, {kg, kp}) do
    {
      fn(r) -> kg.(lg.(r)) end,
      fn(a, r) -> lp.(kp.(a, lg.(r)), r) end
    }
  end

  def compose(lenses) when is_list(lenses) do
    List.foldr(lenses, lens_id(), &compose/2)
  end

  def modify({get, put} = _lens, f) do
    fn(x) -> put.(f.(get.(x)), x) end
  end

  def composed_lens(path) do
    Enum.map(path, fn(x) -> lens(x) end) |> compose()
  end

  def set(obj, path, val) do
    (modify(composed_lens(path), fn(_) -> val end)).(obj)
  end

  def edit(obj, path, fun) do
    (modify(composed_lens(path), fun)).(obj)
  end

end
