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
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizzas", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS orders", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS ingredients", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS pizza_to_ingredients", [], pool: DBConnection.ConnectionPool)
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
      "Create TABLE users (id SERIAL, role VARCHAR(255) NOT NULL, password_hash CHAR(72) NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE pizzas (id SERIAL, name VARCHAR(255) NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE orders (id SERIAL,
                            name VARCHAR(255) NOT NULL,
                            username TEXT,
                            ingredients TEXT)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE ingredients (id SERIAL,
                                  name VARCHAR(255) NOT NULL)",
      [],
      pool: DBConnection.ConnectionPool
    )

    Postgrex.query!(
      DB,
      "Create TABLE pizza_to_ingredients (pizza_id INTEGER,
                                          ingredients_id INTEGER)",
      [],
      pool: DBConnection.ConnectionPool
    )
  end

  defp seed_data() do
    IO.puts("Seeding data")

    Postgrex.query!(
      DB,
      "INSERT INTO users(role, password_hash) VALUES($1, $2)",
      ["admin", Bcrypt.hash_pwd_salt("a")],
      pool: DBConnection.ConnectionPool
    )

    TableHandler.add_rows("pizzas", ["Margherita", "Capricciosa", "Marinara", "Quattro formaggi", "Prosciutto e funghi", "Ortolana", "Quattro stagioni", "Diavola"])
    TableHandler.add_rows("ingredients", ["Tomatsås", "Mozzarella", "Basilika", "Skinka", "Svamp", "Kronärtskocka", "Parmesan", "Pecorino", "Gorgonzola", "Paprika", "Aubergine", "Zucchini", "Oliver", "Salami", "Chili"])
  end
end
