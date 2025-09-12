defmodule Pluggy.UserController do

  import Pluggy.Template, only: [render: 1]
  import Plug.Conn, only: [send_resp: 3]

  # def login(conn, params) do

  #   username = params["username"]
  #   password = params["pwd"]

  #    #Bör antagligen flytta SQL-anropet till user-model (t.ex User.find)
  #   result =
  #     Postgrex.query!(DB, "SELECT id, password_hash FROM users WHERE username = $1", [username],
  #       pool: DBConnection.ConnectionPool
  #     )

  #   case result.num_rows do
  #     # no user with that username
  #     0 ->
  #       redirect(conn, "/fruits")
  #     # user with that username exists
  #     _ ->
  #       [[id, password_hash]] = result.rows

  #       # make sure password is correct
  #       if Bcrypt.verify_pass(password, password_hash) do
  #         Plug.Conn.put_session(conn, :user_id, id)
  #         |> redirect("/fruits") #skicka vidare modifierad conn
  #       else
  #         redirect(conn, "/fruits")
  #       end
  #   end
  # end

  def index(conn) do
    send_resp(conn, 200, render("pizzas/login"))
  end

  def create(conn, params) do

    username = params["username"]
    password = params["password"]

  	hashed_password = Bcrypt.hash_pwd_salt(params["password"])

   	Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.ConnectionPool])
   	redirect(conn, "/")
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

end
