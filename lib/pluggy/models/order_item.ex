defmodule Pluggy.OrderItem do
  defstruct(id: nil, order_id: nil, pizza_id: nil, extra_ingredients: nil, glutenfri: false, familjepizza: false)

  alias Pluggy.OrderItem


  def get_order_items(order_id) do
    Postgrex.query!(DB, "SELECT * FROM order_items WHERE order_id = $1", [order_id]).rows
    |> to_struct_list()
  end


  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM orders WHERE id = $1", [String.to_integer(id)])
  end

  def new(name) do
    Postgrex.query!(
      DB,
      "INSERT INTO orders(customer, pizza_name, extra_ingredients, glutenfri, familjepizza, status) VALUES($1, $2, $3, $4, $5, $6)",
      ["", name, nil, false, false, "kundvagn"])
  end

  def to_struct_list(rows) do
    for [id, order_id, pizza_id, extra_ingredients, glutenfri, familjepizza] <- rows do
      %OrderItem{id: id,
      order_id: order_id,
      pizza_id: pizza_id,
      extra_ingredients: extra_ingredients,
      glutenfri: glutenfri,
      familjepizza: familjepizza,}
    end
  end
end
