defmodule Pluggy.Pizza do

  #Hämtar alla pizzor och deeras korrelerade ingredienser i form av en lista, där varje pizza och ingrdiens också är en lista
  def all_pizza_ingredients do
    Postgrex.query!(DB, "SELECT pizzas.name, ingredients.name  FROM pizza_to_ingredients INNER JOIN pizzas ON pizza_id = pizzas.id INNER JOIN ingredients ON ingredients_id = ingredients.id;", []).rows
  end

  #Gör om listan med alla pizzor och ingredienser till en map där
  def pizza_grouped do
  all_pizza_ingredients()
  |> Enum.group_by(
    fn [pizza, _ingrediens] -> pizza end,
    fn [_pizza, ingrediens] -> ingrediens end
  )
  end

end
