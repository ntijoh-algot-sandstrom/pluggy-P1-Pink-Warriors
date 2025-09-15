defmodule Mix.Tasks.Seed do
  use Mix.Task

  alias Pluggy.TableHandler

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run("app.start")
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizza_to_ingredients", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS orders", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS ingredients", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")

    Postgrex.query!(
      DB,
      "Create TABLE fruits (id SERIAL, name VARCHAR(255) NOT NULL, tastiness INTEGER NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE users (id SERIAL, username VARCHAR(255) NOT NULL, role VARCHAR(255) NOT NULL, password_hash CHAR(72) NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE pizzas (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE orders (id SERIAL,
                            pizza_name VARCHAR(255) NOT NULL,
                            customer TEXT,
                            extra_ingredients TEXT[],
                            glutenfri BOOLEAN NOT NULL DEFAULT FALSE,
                            familjepizza BOOLEAN NOT NULL DEFAULT FALSE,
                            status TEXT NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE ingredients (id SERIAL PRIMARY KEY,
                                  name VARCHAR(255) NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE pizza_to_ingredients (pizza_id INTEGER NOT NULL REFERENCES pizzas(id),
                                          ingredients_id INTEGER NOT NULL REFERENCES ingredients(id),
                                          PRIMARY KEY (pizza_id, ingredients_id))",
      [],
      pool: DBConnection.ConnectionPool
    )
  end

  defp seed_data() do
    IO.puts("Seeding data")

    Postgrex.query!(
      DB,
      "INSERT INTO users(username, role, password_hash) VALUES($1, $2, $3)",
      ["Tony","admin", Bcrypt.hash_pwd_salt("123")],
      pool: DBConnection.ConnectionPool
    )

    TableHandler.add_rows("pizzas", ["Margherita", "Capricciosa", "Marinara", "Quattro formaggi", "Prosciutto e funghi", "Ortolana", "Quattro stagioni", "Diavola"])
    TableHandler.add_rows("ingredients", ["Tomatsås", "Mozzarella", "Basilika", "Skinka", "Svamp", "Kronärtskocka", "Parmesan", "Pecorino", "Gorgonzola", "Paprika", "Aubergine", "Zucchini", "Oliver", "Salami", "Chili"])
    TableHandler.add_to_relation([[1, 1], [1, 2], [1, 3], [2, 1], [2, 2], [2, 4], [2, 5], [2, 6], [3, 1], [4, 1], [4, 2], [4, 7], [4, 8], [4, 9], [5, 1], [5, 2], [5, 4], [5, 5], [6, 1], [6, 2], [6, 10], [6, 11], [6, 12], [7, 1], [7, 2], [7, 4], [7, 5], [7, 6], [7, 13], [8, 1], [8, 2], [8, 14], [8, 10], [8, 15]])
  end
end
