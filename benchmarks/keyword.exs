build = fn length ->
  list =
    for x <- 1..length do
      {:"#{x}", "#{x}"}
    end

  {list, :"#{length}"}
end

fun_tuple = fn current_value -> {current_value, current_value} end
fun_keep = fn _current_value -> :keep end

Benchee.run(
  [
    # get_and_update/3
    "original (tuple): Keyword.get_and_update/3": fn {map, last_key} ->
      Keyword.get_and_update(map, last_key, fun_tuple)
    end,
    # "patched (tuple): Keyword.Patched.get_and_update/3": fn {map, last_key} ->
    #   Keyword.Patched.get_and_update(map, last_key, fun_tuple)
    # end,
    "patched (keep): Keyword.Patched.get_and_update/3": fn {map, last_key} ->
      Keyword.Patched.get_and_update(map, last_key, fun_keep)
    end,

    # get_and_update!/3
    "original  (tuple): Keyword.get_and_update!/3": fn {map, last_key} ->
      Keyword.get_and_update!(map, last_key, fun_tuple)
    end,
    # "patched (tuple) Keyword.Patched.get_and_update!/3": fn {map, last_key} ->
    #   Keyword.Patched.get_and_update!(map, last_key, fun_tuple)
    # end,
    "patched (keep): Keyword.Patched.get_and_update!/3": fn {map, last_key} ->
      Keyword.Patched.get_and_update!(map, last_key, fun_keep)
    end,

    # get_and_update/1: key does not exist
    "original (tuple) - key does not exist: Keyword.get_and_update/3": fn {map, last_key} ->
      Keyword.get_and_update(map, last_key, fun_tuple)
    end,
    # "patched (tuple) - key does not exist: Keyword.Patched.get_and_update/3": fn {map, last_key} ->
    #   Keyword.Patched.get_and_update(map, last_key, fun_tuple)
    # end,
    "patched (keep) - key does not exist: Keyword.Patched.get_and_update/3": fn {map, last_key} ->
      Keyword.Patched.get_and_update(map, last_key, fun_keep)
    end
  ],
  inputs: [
    # list_10: build.(10),
    list_100: build.(100),
    list_1000: build.(1000),
    list_10_000: build.(10_000),
    list_100_000: build.(100_000)
  ],
  time: 2
  # memory_time: 2
)
