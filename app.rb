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

get("/pokedex/new") do
  slim :"pokedex/new"
end

get("/pokedex/:id") do
  @pokemon = db.execute(
    "SELECT * FROM pokemons WHERE id = ?",
    params[:id].to_i
  ).first

  slim :"pokedex/show" if @pokemon
end

get("/pokedex/:id/edit") do
  id = params[:id].to_i

  @pokemon = db.execute(
    "SELECT * FROM pokemons WHERE id = ?",
    id
  ).first

  slim :"pokedex/edit"
end

post("/pokedex") do

  name = params[:name]
  location = params[:location]

  db.execute(
    "INSERT INTO pokemons (name, location)
     VALUES (?,?)",
    [name, location]
  )

  redirect("/pokedex")
end

post("/pokedex/:id/edit") do

  id = params[:id].to_i

  name = params[:name]
  location = params[:location]

  db.execute(
    "UPDATE pokemons
     SET name=?, location=?
     WHERE id=?",
    [name, location, id]
  )

  redirect("/pokedex")
end
post("/pokedex/:id/delete") do

  id = params[:id].to_i

  db.execute(
    "DELETE FROM pokemons WHERE id=?",
    id
  )

  redirect("/pokedex")
end