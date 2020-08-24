class View
  # Recebe um array de recipes e exibe para o usuário
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1} | #{recipe.name} | #{recipe.description}"
    end
  end

  def ask_recipe_name
    puts "Enter recipe name:"
    gets.chomp
  end

  def ask_recipe_description
    puts "Enter recipe description:"
    gets.chomp
  end

  def ask_recipe_index
    puts "Enter the recipe number:"
    gets.chomp.to_i - 1
  end

  def ask_ingredient
    puts "Enter the ingredient name:"
    gets.chomp
  end

  def list_recipes_from_web(recipes_from_web)
    recipes_from_web.each_with_index do |recipe, index|
      puts "#{index + 1} - #{recipe[0]}"
    end
  end




end
