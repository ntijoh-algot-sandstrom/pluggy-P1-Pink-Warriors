defmodule Pluggy.User do

  defstruct(id: nil, username: "")

  def is_user?(username) do
    result = Postgrex.query!(DB, "SELECT 1 FROM users WHERE username = $1 LIMIT 1", [username])

    case result.num_rows do
      0 -> false
      _ -> true
    end
  end

  def login_user(username) do
    result = Postgrex.query!(DB, "SELECT id, role, password_hash FROM users WHERE username = $1 LIMIT 1", [username])
    result
  end


  def is_admin?(conn) do

    role = Plug.Conn.get_session(conn, :user_role)

    cond do
      role == "admin" -> true
      true -> false
    end

  end

  # def get(id) do
  #   Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
  #     pool: DBConnection.ConnectionPool
  #   ).rows
  #   |> to_struct
  # end

  # def to_struct([[id, username]]) do
  #   %User{id: id, username: username}
  # end

  # def get_role do
  #   Postgrex.query!(DB, "SELECT role, username FROM users WHERE id = $1 LIMIT 1", [id],
  #     pool: DBConnection.ConnectionPool
  #    ).rows
  # end

end
