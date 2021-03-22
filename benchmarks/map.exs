build = fn size ->
  map =
    for x <- 1..size do
      {:"#{x}", "#{x}"}
    end
    |> Enum.into(%{})

  {map, :"#{size}"}
end

fun_tuple = fn current_value -> {current_value, current_value} end
fun_keep = fn _current_value -> :keep end

Benchee.run(
  [
    # get_and_update/3
    "original (tuple): Map.get_and_update/3": fn {map, last_key} ->
      Map.get_and_update(map, last_key, fun_tuple)
    end,
    # "patched (tuple): Map.Patched.get_and_update/3": fn {map, last_key} ->
    #   Map.Patched.get_and_update(map, last_key, fun_tuple)
    # end,
    "patched (keep): Map.Patched.get_and_update/3": fn {map, last_key} ->
      Map.Patched.get_and_update(map, last_key, fun_keep)
    end,

    # get_and_update!/3
    "original  (tuple): Map.get_and_update!/3": fn {map, last_key} ->
      Map.get_and_update!(map, last_key, fun_tuple)
    end,
    # "patched (tuple) Map.Patched.get_and_update!/3": fn {map, last_key} ->
    #   Map.Patched.get_and_update!(map, last_key, fun_tuple)
    # end,
    "patched (keep): Map.Patched.get_and_update!/3": fn {map, last_key} ->
      Map.Patched.get_and_update!(map, last_key, fun_keep)
    end,

    # get_and_update/1: key does not exist
    "original (tuple) - key does not exist: Map.get_and_update/3": fn {map, last_key} ->
      Map.get_and_update(map, last_key, fun_tuple)
    end,
    # "patched (tuple) - key does not exist: Map.Patched.get_and_update/3": fn {map, last_key} ->
    #   Map.Patched.get_and_update(map, last_key, fun_tuple)
    # end,
    "patched (keep) - key does not exist: Map.Patched.get_and_update/3": fn {map, last_key} ->
      Map.Patched.get_and_update(map, last_key, fun_keep)
    end
  ],
  inputs: [
    # map_10: build.(10),
    map_100: build.(100),
    map_1000: build.(1000),
    map_10_000: build.(10_000),
    map_100_000: build.(100_000)
  ],
  time: 2
  # memory_time: 2
)
