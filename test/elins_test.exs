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

  test "edit multiple values using different functions" do
    assert (
      @kitten |> editVals(%{ name: &String.upcase/1, color: %{ r: &(0.5 * &1) } }).()
    ) == %{name: "MR. BIGGLESWORTH", color: %{r: 0.5, g: 1.0, b: 1.0}}
  end

end
