defmodule Pluggy.Order do
  defstruct(id: nil, session_id: "", customer: "", inserted_at: "", updated_at: "", status: "")

  import Plug.Conn
  alias Pluggy.Order

  def get_or_create_order(conn) do
    session_id = Plug.Conn.get_session(conn, :session_id)

    {session_id, conn} =
      case session_id do
        nil ->
          result =
            Postgrex.query!(
              DB,
              "INSERT INTO orders (status) VALUES ('kundvagn')
               RETURNING session_id, id",
              []
            )

          [%{"session_id" => new_id}] = result.rows |> Enum.map(&Enum.zip(result.columns, &1)) |> Enum.map(&Map.new/1)
          {new_id, put_session(conn, :session_id, new_id)}

        id ->
          {id, conn}
      end

    result =
      Postgrex.query!(
        DB,
        "SELECT * FROM orders WHERE session_id = $1 AND status = 'kundvagn' LIMIT 1",
        [session_id]
      )

      order =
        case result.rows do
          [] ->
            Postgrex.query!(
              DB,
              "INSERT INTO orders (session_id, status) VALUES ($1, 'kundvagn')
              RETURNING *",
              [session_id]
            )
            |> row_to_map()

          _ ->
            row_to_map(result)
        end

      {conn, order}
    end

  def add_item(id, order, params) do
    pizza_id = String.to_integer(id)
    ingredients = params["ingredient"]
    gluten = params["glutenfri"]
    familje = params["familjepizza"]

    case params do
      nil -> Postgrex.query!(DB, "INSERT INTO order_items (order_id, pizza_id) VALUES ($1, $2)",[order["id"], pizza_id])
      _ -> Postgrex.query!(DB, "INSERT INTO order_items (order_id,
                                            pizza_id,
                                            extra_ingredients,
                                            glutenfri,
                                            familjepizza)
                                            VALUES ($1, $2, $3, $4, $5)",
                                            [order["id"], pizza_id, ingredients, !!gluten, !!familje])
    end
  end


  defp row_to_map(%Postgrex.Result{rows: rows, columns: cols}) do
    [row] = rows
    Enum.zip(cols, row) |> Map.new()
  end

  def update_customer(id, params) do
    customer = params["customer"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE orders SET customer = $1 WHERE id = $2",
      [customer, id]
    )
  end

  def send_order(id) do
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE orders SET status = 'tillagas' WHERE id = $1",
      [id]
    )
  end


  def get_all_orders() do
      Postgrex.query!(
        DB,
        "SELECT * FROM orders WHERE status = 'tillagas' OR status = 'färdiglagad'",[]
        ).rows
        |> to_struct_list()
  end

  def update(id, params) do
    status = params["status"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE orders SET status = $1 WHERE id = $2",
      [status, id]
    )
  end

  def to_struct_list(rows) do
    for [id, session_id, customer, inserted_at, updated_at, status] <- rows do
      %Order{
      id: id,
      session_id: session_id,
      customer: customer,
      inserted_at: inserted_at,
      updated_at: updated_at,
      status: status
     }
    end
  end
end
