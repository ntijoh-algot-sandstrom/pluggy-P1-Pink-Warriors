defmodule Pluggy.PizzaController do
  alias Pluggy.Pizza
  alias Pluggy.Ingredients

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3, get_session: 2, put_session: 3]

  def edit(conn, id) do
    pizza = Pizza.get(id) #with ingredients
    remaining = Ingredients.remaining(pizza.ingredients) #remaining ingredients

    send_resp(conn, 200, render("fruits/edit", pizza: pizza, remaining_ingredients: remaining))
  end

  def create(conn, params) do # params = ["Tomatsås", "Basikila"]
    pizza_name = Pizza.get("1") # [1, "margharita"]
    Pizza.create(params, pizza_name)

    redirect(conn, "/edit/1")
  end

  def add_order(conn, order_id) do
    current = get_session(conn, :order_ids) || []
    put_session(conn, :order_ids, [order_id | current])
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
