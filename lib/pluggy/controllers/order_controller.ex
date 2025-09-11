  defmodule Pluggy.OrderController do
  require IEx

  alias Pluggy.Order
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def orders(conn) do
    send_resp(conn, 200, render("pizzas/orders", orders: Order.get_all_orders()))
  end

  def remove(conn, id) do
    Order.delete(id)
    redirect(conn, "/orders")
  end

  def update(conn, id, params) do
    Order.update(id, params)
    redirect(conn, "/orders")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
