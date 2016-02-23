defmodule Elins do
  # use Curry

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

  # getter/setter that doesn't change anything
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
  def set(path, val) do
    modify(composed_lens(path), fn(_) -> val end)
  end

  # change a property val for a given path with a function
  def edit(path, fun) do
    modify(composed_lens(path), fun)
  end

  # alter using a (nested) structure (maps) by setting values -- essentially acts as a deep merge
  def setVals(v, path \\ [])
  def setVals(map, path) when is_list(path) and is_map(map) do
    map |> Enum.map(fn({k,v}) ->
      setVals(v, path ++ [k])
    end) |> Fun.comp()
  end
  def setVals(v, path) when is_list(path) do
    set(path, v)
  end

  # alter using a (nested) structure (maps/lists) of editing functions
  def editVals(v, path \\ [])
  def editVals(map, path) when is_list(path) and is_map(map) do
    map |> Enum.map(fn({k,v}) ->
      editVals(v, path ++ [k])
    end) |> Fun.comp()
  end
  def editVals(fun, path) when is_list(path) and is_function(fun, 1) do
    edit(path, fun)
  end
  def editVals([v], path) when is_list(path) do
    edit(path, &(Enum.map(&1, editVals(v, []))))
  end

end
