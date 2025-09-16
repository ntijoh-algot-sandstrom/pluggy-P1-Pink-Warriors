defmodule Pluggy.Cart do
  defstruct(id: nil, session_id: "", customer: "", inserted_at: "", updated_at: "", status: "")

  alias Pluggy.Cart
  alias Pluggy.OrderItem


  def get_order(conn) do
    session_id = Plug.Conn.get_session(conn, :session_id)

    order =
      Postgrex.query!(
        DB,
        "SELECT * FROM orders WHERE session_id = $1 AND status = 'kundvagn' LIMIT 1",
        [session_id]
        ).rows
        |> to_struct_list()

    if order == [] do
      OrderItem.get_order_items(0)
    else
      formatted = hd order
      OrderItem.get_order_items(formatted.id)
    end
  end

  def to_struct_list(rows) do
    for [id, session_id, customer, inserted_at, updated_at, status] <- rows do
      %Cart{
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
