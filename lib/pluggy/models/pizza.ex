defmodule Pluggy.Pizza do
  defstruct(id: nil, name: "", ingredients: [])
  
  alias Pluggy.Pizza
  alias Pluggy.Pizza

  def get(id) do
    ingredients = get_ingredients(id)
    pizza = hd Postgrex.query!(DB, "SELECT * FROM pizzas WHERE id = $1 LIMIT 1", [String.to_integer(id)]).rows
    pizza_with_ingredients = pizza ++ [ingredients]
    to_struct(pizza_with_ingredients)
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

  #Hämtar alla pizzor och deeras korrelerade ingredienser i form av en lista, där varje pizza och ingrdiens också är en lista
  def all_pizza_ingredients do
    Postgrex.query!(DB, "SELECT pizzas.id, pizzas.name, ingredients.name FROM pizza_to_ingredients INNER JOIN pizzas ON pizza_id = pizzas.id INNER JOIN ingredients ON ingredients_id = ingredients.id;", []).rows
  end

  def all() do
    Postgrex.query!(DB, "SELECT * FROM pizzas", []).rows
    |> to_struct_list
  end

  #Gör om listan med alla pizzor och ingredienser till en map där
  def pizza_grouped do
  all_pizza_ingredients()
  |> Enum.group_by(
    fn [id, pizza, _ingrediens] -> {id, pizza} end,
    fn [_id, _pizza, ingrediens] -> ingrediens end
  )
  end

  def get_pizza_id(name) do
    Postgrex.query!(DB, "SELECT id FROM pizzas WHERE name = $1 LIMIT 1", [name]).rows
    |> List.first() |> List.first()
  end

  def get_pizza_name(id) do
    Postgrex.query!(DB, "SELECT name FROM pizzas WHERE id = $1 LIMIT 1", [id]).rows
    |> List.first()
  end

  def get_ingredients(id) do
    Postgrex.query!(DB, "SELECT name FROM ingredients JOIN pizza_to_ingredients ON id = ingredients_id WHERE pizza_id = #{id}", []).rows
  end

  def to_struct_list(rows) do
    for [id, name] <- rows, do: %Pizza{id: id, name: name}
  end

end
