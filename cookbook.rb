require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    load_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_csv
  end

  private

  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description] # No load esse array é o row
      end
    end
  end

  def load_csv
    CSV.foreach(@csv_file_path) do |row|
      # row = ['feijoada', 'carne de porco com arroz']
      name = row[0]
      description = row[1]
      @recipes << Recipe.new(name, description)
    end
  end
end
