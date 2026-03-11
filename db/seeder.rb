require 'sqlite3'

db = SQLite3::Database.new("db/pokedex.db")

def seed!(db)
  puts "Using db file: db/pokedex.db"
  puts "🧹 Dropping old tables..."
  drop_tables(db)
  puts "🧱 Creating tables..."
  create_tables(db)
  puts "🍎 Populating tables..."
  populate_tables(db)
  puts "✅ Done seeding the database!"
end

def drop_tables(db)
  db.execute('DROP TABLE IF EXISTS pokemons')
end

def create_tables(db)
  db.execute('CREATE TABLE pokemons (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL, 
              location TEXT,
              image TEXT,
              shiny INTEGER DEFAULT 0,
              found INTEGER DEFAULT 0
              )')
end

def populate_tables(db)
  db.execute('INSERT INTO pokemons (name, location, image, shiny, found) VALUES ("Pikachu", "Viridian Forest", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png", 0, 1)')
  db.execute('INSERT INTO pokemons (name, location, image, shiny, found) VALUES ("Charmander", "Starter Pokémon", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png", 0, 0)')
  db.execute('INSERT INTO pokemons (name, location, image, shiny, found) VALUES ("Bulbasaur", "Starter Pokémon", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png", 0, 0)')
end

seed!(db)