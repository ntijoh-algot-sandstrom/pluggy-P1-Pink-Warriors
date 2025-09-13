  defmodule Pluggy.OrderController do
  require IEx

  alias Pluggy.Order
  alias Pluggy.Pizza
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def orders(conn) do
    send_resp(conn, 200, render("pizzas/orders", orders: Order.get_all_orders()))
  end

  def create(conn, params) do # params = %{pzza_id: "2", ingredients: ["Tomatsås", "Basikila"]}
    pizza = Pizza.get(params["pizza_id"]) # [1, "margharita"]

    Order.create(to_i(params["ingredient"]), pizza.name)

    redirect(conn, "/orders")
  end

  def remove(conn, id) do
    Order.delete(id)
    redirect(conn, "/orders")
  end

  def update(conn, id, params) do
    Order.update(id, params)
    redirect(conn, "/orders")
  end

  def to_i(list, acc \\ [])
  def to_i([], acc), do: List.flatten(acc)
  def to_i([head | tail], acc) do
    to_i(tail, [Postgrex.query!(DB, "SELECT id FROM ingredients WHERE name = '#{head}'").rows | acc])
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
