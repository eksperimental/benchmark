defmodule List.New do
  def keysort(list, position, sorter \\ :asc)

  def keysort(list, position, :asc) when is_list(list) and is_integer(position) do
    :lists.keysort(position + 1, list)
  end

  def keysort(list, position, sorter) when is_list(list) and is_integer(position) do
    :lists.sort(keysort_fun(sorter, position + 1), list)
  end

  defp keysort_fun(sorter, position) when is_function(sorter, 2),
    do: &sorter.(:erlang.element(position, &1), :erlang.element(position, &2))

  defp keysort_fun(:asc, position),
    do: &(:erlang.element(position, &1) <= :erlang.element(position, &2))

  defp keysort_fun(:desc, position),
    do: &(:erlang.element(position, &1) >= :erlang.element(position, &2))

  defp keysort_fun(module, position) when is_atom(module),
    do: &(module.compare(:erlang.element(position, &1), :erlang.element(position, &2)) != :gt)

  defp keysort_fun({:asc, module}, position) when is_atom(module),
    do: &(module.compare(:erlang.element(position, &1), :erlang.element(position, &2)) != :gt)

  defp keysort_fun({:desc, module}, position) when is_atom(module),
    do: &(module.compare(:erlang.element(position, &1), :erlang.element(position, &2)) != :lt)
end
