  defmodule Pluggy.OrderController do
  require IEx

  alias Pluggy.Order
  alias Pluggy.Pizza
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def orders(conn) do
    send_resp(conn, 200, render("pizzas/orders", orders: Order.get_all_orders(), admin: User.is_admin?(conn)))
  end

  def create(conn, params) do
    pizza = Pizza.get(params["pizza_id"])
    Order.create(params, pizza.name)

    redirect(conn, "/")
  end

  def buy(conn, params) do
    id = params["pizza_id"]
    pizza = Pizza.get(id)
    Order.buy(pizza.name, pizza.ingredients)
    redirect(conn, "/")
  end

  def remove(conn, id) do
    case User.is_admin?(conn) do
      true ->
        Order.delete(id)
        redirect(conn, "/orders")

      false -> redirect(conn, "/orders")
    end
  end

  def update(conn, id, params) do
    case User.is_admin?(conn) do
      true -> Order.update(id, params)
              redirect(conn, "/orders")

      false -> redirect(conn, "/orders")
    end
  end

  # def to_i(list, acc \\ [])
  # def to_i([], acc), do: List.flatten(acc)
  # def to_i([head | tail], acc) do
  #   to_i(tail, [Postgrex.query!(DB, "SELECT id FROM ingredients WHERE name = '#{head}'").rows | acc])
  # end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
