defmodule Enum.Optimized do
  def sort_by(enumerable, mapper, sorter \\ &<=/2)

  def sort_by(enumerable, mapper, :desc) do
    enumerable
    |> Enum.reduce([], &[{&1, mapper.(&1)} | &2])
    |> List.keysort(1, :asc)
    |> List.foldl([], &[elem(&1, 0) | &2])
  end

  def sort_by(enumerable, mapper, sorter) do
    enumerable
    |> Enum.map(&{&1, mapper.(&1)})
    |> List.keysort(1, sorter)
    |> Enum.map(&elem(&1, 0))
  end
end
