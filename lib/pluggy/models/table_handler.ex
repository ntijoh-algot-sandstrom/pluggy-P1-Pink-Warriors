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

  def add_to_relation(rows) do
    Enum.map(rows, fn(e) ->
      [head | tail] = e
      Postgrex.query!(
          DB,
          "INSERT INTO pizza_to_ingredients(pizza_id, ingredients_id) VALUES($1, $2)",
          [head, hd tail],
          pool: DBConnection.ConnectionPool
      ) end
    )
  end
end
