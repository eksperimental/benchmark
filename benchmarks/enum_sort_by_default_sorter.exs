keyword = fn length ->
  for x <- 1..length do
    {:"#{x}", "#{x}"}
  end
  |> Enum.shuffle()
end

map = fn length ->
  keyword.(length) |> Map.new()
end

mapper = & &1

numbers = [
  100,
  1000,
  10_000,
  100_000,
]

Benchee.run(
  [
    "Enum.sort_by/3 &<=/2": fn enumerable ->
      Enum.sort_by(enumerable, mapper, &<=/2)
    end,

    "Enum.sort_by/3 :asc": fn enumerable ->
      Enum.sort_by(enumerable, mapper, :asc)
    end,
  ],
  inputs:
    for {kind, fun} <- [{:keyword, keyword}, {:map, map}],
      n <- numbers do
      {:"#{kind}_#{n}", apply(fun, [n])}
    end,
  time: 2,
  memory_time: 2
)
