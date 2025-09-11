defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", ingredients: [])

  alias Pluggy.Pizza

  def get(id) do
    ingredients = get_ingredients(id)
    pizza = hd Postgrex.query!(DB, "SELECT * FROM pizzas WHERE id = $1 LIMIT 1", [String.to_integer(id)]).rows
    pizza_with_ingredients = pizza ++ [ingredients]
    to_struct(pizza_with_ingredients)
  end

  def create(params, name) do
    ingredients = params
    Postgrex.query!(DB, "INSERT INTO orders (name, user, ingredients, status) VALUES ($1, $2, $3, $4)", [name, nil, ingredients, "Varukorgen"])
  end

  def get_ingredients(id) do
    format_ingredients(Postgrex.query!(DB, "SELECT name FROM ingredients JOIN pizza_to_ingredients ON id = ingredients_id WHERE pizza_id = #{id}").rows)
  end

  def format_ingredients(list, acc \\ [])
  def format_ingredients([], acc), do: acc
  def format_ingredients([head | tail], acc) do
    format_ingredients(tail, acc ++ head)
  end

  def to_struct([id, name, ingredients]) do
    %Pizza{id: id, name: name, ingredients: ingredients}
  end
end
