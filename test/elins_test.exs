defmodule ElinsTest do
  use ExUnit.Case
  import Elins

  @kitten %{name: "Mr. Bigglesworth", color: %{r: 1.0, g: 1.0, b: 1.0}}

  test "set" do
    assert (
      @kitten |> set([:color, :b], 0.0).()
    ).color.b == 0.0
  end

  test "edit" do
    assert (
      @kitten |> edit([:color, :g], fn(v) -> 0.5 * v end).()
    ).color.g == 0.5
  end

  test "set empty path" do
    assert (
      @kitten |> set([], 123).()
    ) == 123
  end

  test "edit empty path" do
    assert (
      @kitten |> edit([], fn(_v) -> 123 end).()
    ) == 123
  end

  test "set new key" do
    assert (
      @kitten |> set([:price], 999).()
    ).price == 999
  end

  test "set key in new nested structure" do
    protagonist = "Austin Powers"
    assert (
      @kitten |> set([:owner, :nemesis], protagonist).()
    ).owner.nemesis == protagonist
  end

  test "setVals (deep merge)" do
    assert (
      @kitten |> setVals(%{ name: "Garfield", color: %{ r: 0.5 } }).()
    ) == %{name: "Garfield", color: %{r: 0.5, g: 1.0, b: 1.0}}
  end

  test "edit multiple values using different functions" do
    assert (
      @kitten |> editVals(%{ name: &String.upcase/1, color: %{ r: &(0.5 * &1) } }).()
    ) == %{name: "MR. BIGGLESWORTH", color: %{r: 0.5, g: 1.0, b: 1.0}}
  end

  test "edit through maps and lists" do
    assert (
      %{name: "Mr. Bigglesworth", color: %{r: 1.0, g: 1.0, b: 1.0}, children: [ %{num: 1}, %{num: 2}, %{num: 3} ] }
      |> editVals(%{ name: &String.upcase/1, children: [ %{ num: &(&1 + 1) } ] }).()
    ) == %{name: "MR. BIGGLESWORTH", color: %{r: 1.0, g: 1.0, b: 1.0}, children: [ %{num: 2}, %{num: 3}, %{num: 4} ] }
  end

  test "edit with some properties deriving from others" do
    total = fn(_x, cat) ->
      clr = cat.color
      clr.r + clr.g + clr.b
    end
    assert (
      @kitten |> editVals(%{
        age: fn(_x, cat) -> cat.name |> String.length() end,
        color: %{ r: total, g: total, b: total }
      }).()
    ) == %{name: "Mr. Bigglesworth", age: 16, color: %{r: 3.0, g: 5.0, b: 9.0}}
  end

end
