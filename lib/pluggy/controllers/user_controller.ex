defmodule Pluggy.UserController do

  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do

    error = Plug.Conn.get_session(conn, :error)
    conn = Plug.Conn.delete_session(conn, :error)

    send_resp(conn, 200, render("pizzas/login", error: error))
  end

  def login(conn, params) do

    username = params["username"]
    password = params["password"]


    exists = User.is_user?(username)

    case exists do

      true ->

        result = User.login_user(username)
        [[id, role, password_hash]] = result.rows

        if Bcrypt.verify_pass(password, password_hash) do
          conn
          |> Plug.Conn.put_session( :user_id, id)
          |> Plug.Conn.put_session( :user_role, role)
          |> redirect("/")
        else
          conn
          |> Plug.Conn.clear_session()
          |> Plug.Conn.put_session(:error, "Wrong password or username")
          |> redirect("/users/login")
        end

      _ ->
          conn
          |> Plug.Conn.clear_session()
          |> Plug.Conn.put_session(:error, "Wrong password or username")
          |> redirect("/users/login")
    end

  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

end
