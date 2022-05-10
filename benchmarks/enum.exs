keyword = fn length ->
  for x <- 1..length do
    {:"#{x}", "#{x}"}
  end
  |> Enum.shuffle()
end

map = fn length ->
  keyword.(length) |> Map.new()
end

# dates = fn length ->
#   base = Date.new!(2000, 1, 1)

#   for x <- 1..length//3 do
#     base |> Date.add(x)
#   end
#   |> Enum.shuffle()
# end

mapper = fn
  {_k, v} -> v
  %Date{} = date -> date
end

# sorter_asc = fn
#   left, right when is_binary(left) and is_binary(right) ->
#     byte_size(left) <= byte_size(right)
# end

# sorter_desc = fn
#   left, right when is_binary(left) and is_binary(right) ->
#     byte_size(left) >= byte_size(right)
# end

numbers = [
  100,
  1000,
  10_000,
  100_000
]

Benchee.run(
  [
    # Current
    "Enum.sort_by/3": fn {enumerable, sorter} ->
      Enum.sort_by(enumerable, mapper, sorter)
    end,

    # Optimized
    "Enum.Optimized.sort_by/3": fn {enumerable, sorter} ->
      Enum.Optimized.sort_by(enumerable, mapper, sorter)
    end
  ],
  inputs:
    for {kind, fun} <- [
      {:keyword, keyword},
      {:map, map},
      # {:dates, dates}
    ],
        n <- numbers,
        {sorter_key, sorter_value} <- [
          # {:asc, :asc},-
          {:desc, :desc},
          # {:sorter_fun_desc, sorter_desc},
          # {:sorter_fun_asc, sorter_asc}
        ] do
      {:"#{kind}_#{n}_#{sorter_key}",
       {
         apply(fun, [n]),
         cond do
           kind == :dates && sorter_key == :sorter_fun_desc ->
             {:desc, Date}

           kind == :dates && sorter_key == :sorter_fun_asc ->
             {:asc, Date}

           true ->
             sorter_value
         end
       }}
    end,
  time: 5,
  memory_time: 5
)
