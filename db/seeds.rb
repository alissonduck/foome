# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Este seed irá criar os estados de Paraná e São Paulo,
# Curitiba e sua região metropolitana, além da cidade de São Paulo

# Criando os estados
puts "Criando estados..."
pr = State.find_or_create_by!(
  name: "Paraná",
  abbreviation: "PR"
)

sp = State.find_or_create_by!(
  name: "São Paulo",
  abbreviation: "SP"
)

puts "Estados criados com sucesso!"

# Criando as cidades de São Paulo
puts "Criando cidade de São Paulo..."
City.find_or_create_by!(
  name: "São Paulo",
  state: sp
)

# Criando Curitiba e sua região metropolitana
puts "Criando Curitiba e região metropolitana..."
curitiba_metro_cities = [
  "Curitiba",
  "Araucária",
  "Almirante Tamandaré",
  "Balsa Nova",
  "Bocaiúva do Sul",
  "Campina Grande do Sul",
  "Campo Largo",
  "Campo Magro",
  "Colombo",
  "Contenda",
  "Fazenda Rio Grande",
  "Itaperuçu",
  "Mandirituba",
  "Pinhais",
  "Piraquara",
  "Quatro Barras",
  "Rio Branco do Sul",
  "São José dos Pinhais"
]

curitiba_metro_cities.each do |city_name|
  City.find_or_create_by!(
    name: city_name,
    state: pr
  )
end

puts "Cidades criadas com sucesso!"
puts "Seed finalizado. Foram criados 2 estados e #{1 + curitiba_metro_cities.length} cidades."
