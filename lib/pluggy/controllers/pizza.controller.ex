defmodule Pluggy.PizzaController do
  
  require IEx

  alias Pluggy.Pizza
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    send_resp(conn, 200, render("pizzas/index", user: current_user, pizzas_grouped: Pizza.pizza_grouped()))
  end

end
