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

  slim(:"pokedex/edit")
end

post("/pokedex") do

  name = params[:name]
  location = params[:location]
  image = params[:image]
  shiny = params[:shiny] ? 1 : 0
  found = params[:found] ? 1 : 0

  db.execute(
    "INSERT INTO pokemons (name, location, image, shiny, found)
     VALUES (?,?,?,?,?)",
    [name, location, image, shiny, found]
  )

  redirect("/pokedex")
end

post("/pokedex/:id/edit") do

  id = params[:id].to_i

  name = params[:name]
  location = params[:location]
  image = params[:image]
  shiny = params[:shiny] ? 1 : 0
  found = params[:found] ? 1 : 0

  db.execute(
    "UPDATE pokemons
     SET name=?, location=?, image=?, shiny=?, found=?
     WHERE id=?", 
    [name, location, image, shiny, found, id]
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
post("/pokedex/:id/toggle_shiny") do
  db.execute(
    "UPDATE pokemons SET shiny = 1 - shiny WHERE id=?",
    params[:id]
  )

  redirect "/pokedex"
end
