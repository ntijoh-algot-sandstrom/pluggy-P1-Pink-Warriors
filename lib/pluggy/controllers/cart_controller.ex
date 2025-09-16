defmodule Pluggy.CartController do
  require IEx

  alias Pluggy.Cart
  alias Pluggy.Order
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]



  def index(conn) do
    send_resp(conn, 200, render("pizzas/cart", orders: Cart.get_order(conn)))
  end

  def add_to_cart(conn, id, params \\ nil) do
    {conn, order} = Order.get_or_create_order(conn)
    Order.add_item(id, order, params)
    redirect(conn, "/")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
