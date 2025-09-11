defmodule Pluggy.Ingredients do
  def remaining(list, acc \\ get())
  def remaining([], acc), do: acc
  def remaining([head | tail], acc) do
    remaining(tail, List.delete(acc, head))
  end

  def get(), do: format(Postgrex.query!(DB, "SELECT * FROM ingredients").rows)

  def format(list, acc \\ [])
  def format([], acc), do: acc
  def format([head | tail], acc) do
    name = hd tl head
    format(tail, [name | acc])
  end
end
