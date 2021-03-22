defmodule Enum.Current do
  def sort_by(enumerable, mapper, sorter \\ &<=/2) do
    enumerable
    |> Enum.map(&{&1, mapper.(&1)})
    |> List.New.keysort(1, sorter)
    |> Enum.map(&elem(&1, 0))
  end
end
