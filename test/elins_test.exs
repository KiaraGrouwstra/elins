defmodule ElinsTest do
  use ExUnit.Case
  import Elins

  @kitten %{name: "Mr. Bigglesworth", color: %{r: 1.0, g: 1.0, b: 1.0}}

  test "set" do
    assert set(@kitten, [:color, :b], 0.0).color.b == 0.0
  end

  test "edit" do
    assert edit(@kitten, [:color, :g], fn(v) -> 0.5 * v end).color.g == 0.5
  end

  test "set new key" do
    assert set(@kitten, [:price], 999).price == 999
  end

  test "set key in new nested structure" do
    protagonist = "Austin Powers"
    assert set(@kitten, [:owner, :nemesis], protagonist).owner.nemesis == protagonist
  end

end
