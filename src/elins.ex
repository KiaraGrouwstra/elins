defmodule Elins do

  # getter/setter
  def lens(n) do
    {
      fn(r) ->
        case Map.fetch(r, n) do
          :error -> %{}
          {:ok, val} -> val
        end
      end,
      fn(a, r) -> Map.put(r, n, a) end
    }
  end

  # getter/setter that don't change anything
  def lens_id() do
    {
      fn(x) -> x end,
      fn(a, _x) -> a end
    }
  end

  # combine lenses
  def compose({lg, lp}, {kg, kp}) do
    {
      fn(r) -> kg.(lg.(r)) end,
      fn(a, r) -> lp.(kp.(a, lg.(r)), r) end
    }
  end

  # scale up the combining
  def compose(lenses) when is_list(lenses) do
    List.foldr(lenses, lens_id(), &compose/2)
  end

  # make function (for a lens + lambda) to set an object property
  def modify({get, put} = _lens, f) do
    fn(x) -> put.(f.(get.(x)), x) end
  end

  # get a lens from a list of properties (from root to dest)
  def composed_lens(path) do
    Enum.map(path, fn(x) -> lens(x) end) |> compose()
  end

  # set a property val for a given path
  def set(obj, path, val) do
    (modify(composed_lens(path), fn(_) -> val end)).(obj)
  end

  # change a property val for a given path with a function
  def edit(obj, path, fun) do
    (modify(composed_lens(path), fun)).(obj)
  end

end
