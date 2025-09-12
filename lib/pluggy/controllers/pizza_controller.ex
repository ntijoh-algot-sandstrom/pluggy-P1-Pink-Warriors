defmodule Pluggy.PizzaController do
  require IEx

  alias Pluggy.Pizza
  alias Pluggy.Ingredients

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3, get_session: 2, put_session: 3]

  def index(conn) do

    send_resp(conn, 200, render("pizzas/index", pizzas_grouped: Pizza.pizza_grouped()))

  end

  def edit(conn, id) do
    pizza = Pizza.get(id) #with ingredients
    remaining = Ingredients.remaining(pizza.ingredients) #remaining ingredients

    send_resp(conn, 200, render("fruits/edit", pizza: pizza, remaining_ingredients: remaining))
  end

  def add_order(conn, order_id) do
    current = get_session(conn, :order_ids) || []
    put_session(conn, :order_ids, [order_id | current])
  end
end
