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
              )')
end

def populate_tables(db)
  db.execute('INSERT INTO pokemons (name, location) VALUES ("Pikachu", "Viridian Forest",)')
  db.execute('INSERT INTO pokemons (name, location) VALUES ("Charmander", "Starter Pokémon")')
  db.execute('INSERT INTO pokemons (name, location) VALUES ("Bulbasaur", "Starter Pokémon")')
end

seed!(db)