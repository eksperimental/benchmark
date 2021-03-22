defmodule Enum.Optimized do
  @compile {:inline, sort_by_desc: 3}

  def sort_by(enumerable, mapper, sorter \\ &<=/2)

  def sort_by(enumerable, mapper, :desc),
    do: sort_by_desc(enumerable, mapper, :desc)

  def sort_by(enumerable, mapper, {:desc, _module} = sorter),
    do: sort_by_desc(enumerable, mapper, sorter)

  def sort_by(enumerable, mapper, sorter) do
    enumerable
    |> Enum.map(&{&1, mapper.(&1)})
    |> List.New.keysort(1, sorter)
    |> Enum.map(&elem(&1, 0))
  end

  defp sort_by_desc(enumerable, mapper, sorter) do
    enumerable
    |> Enum.reduce([], &[{&1, mapper.(&1)} | &2])
    |> List.keysort(1, invert_sorter(sorter))
    |> List.foldl([], &[elem(&1, 0) | &2])
  end

  defp invert_sorter(:asc), do: :desc
  defp invert_sorter(:desc), do: :asc
  defp invert_sorter({order, module}), do: {invert_sorter(order), module}
end
