defmodule Pluggy.Order do
  defstruct(id: nil, customer: "", pizza_name: "", extra_ingredients: "", glutenfri: false, familjepizza: true, status: "")

  alias Pluggy.Order

  def get_all_orders() do
    Postgrex.query!(DB, "SELECT * FROM orders", []).rows
    |> to_struct_list
  end

  def create(ingredients, name) do
    Postgrex.query!(DB, "INSERT INTO orders (pizza_name,
                                            customer,
                                            extra_ingredients,
                                            glutenfri,
                                            familjepizza,
                                            status)
                                            VALUES ($1, $2, $3, $4, $5, $6)",
                                            [name, nil, ingredients, false, false, "Varukorgen"])
  end

  def update(id, params) do
    status = params["status"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE orders SET status = $1 WHERE id = $2",
      [status, id]
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM orders WHERE id = $1", [String.to_integer(id)])
  end

  def to_struct_list(rows) do
    for [id, pizza_name, customer, extra_ingredients, glutenfri, familjepizza, status] <- rows do
      %Order{id: id,
      customer: customer,
      pizza_name: pizza_name,
      extra_ingredients: extra_ingredients,
      glutenfri: glutenfri,
      familjepizza: familjepizza,
      status: status}
    end
  end
end
