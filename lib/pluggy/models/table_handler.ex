defmodule Pluggy.TableHandler do
  def add_rows(table, list) do
    Enum.map(list, fn(e) ->
      Postgrex.query!(
          DB,
          "INSERT INTO #{table}(name) VALUES($1)",
          [e],
          pool: DBConnection.ConnectionPool
      ) end
    )
  end
end
