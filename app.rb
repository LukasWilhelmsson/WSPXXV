require "sinatra"
require "sqlite3"
require "slim"
require "sinatra/reloader"

def db
  SQLite3::Database.new("db/pokedex.db", results_as_hash: true)
end

get("/") do
  redirect("/pokedex")
end

get("/pokedex") do

  query = params["q"]

  if query && !query.empty?
    @pokemons = db.execute(
      "SELECT * FROM pokemons WHERE name LIKE ?",
      ["%#{query}%"]
    )
  else
    @pokemons = db.execute("SELECT * FROM pokemons")
  end

  @pokemons ||= []

  slim :"pokedex/index"
end