defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  alias Pluggy.OrderController
  alias Pluggy.UserController
  alias Pluggy.PizzaController
  alias Pluggy.CartController

  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "pizza",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    log: :debug
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)


  get("/", do: PizzaController.index(conn))

  get("/cart", do: CartController.index(conn))
  post("/cart/:id/add", do: CartController.add_to_cart(conn, id))
  post("sendorder/:id", do: OrderController.order(conn, id, conn.body_params))

  get("/edit/:id", do: PizzaController.edit(conn, id))
  get("/orders", do: OrderController.orders(conn))
  get("/users/login", do: UserController.index(conn))

  post("/users/login", do: UserController.login(conn, conn.body_params))
  post("orders/:id/remove", do: OrderController.remove(conn, id))
  post("orders/:id/edit", do: OrderController.update(conn, id, conn.body_params))
  post("/orders/:id", do: CartController.add_to_cart(conn, id, conn.body_params))


  # post("/users/login", do: UserController.login(conn, conn.body_params))
  # post("/users/logout", do: UserController.logout(conn))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
