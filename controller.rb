require_relative 'view'

class Controller
  def initialize(repository)
    @cookbook = repository
    @view = View.new
  end

  def list
    # 1. Pegar todas as recipes
    recipes = @cookbook.all
    # 2. Mandar as recipes para a view exibir
    @view.display(recipes)
  end

  def create
    # 1. Perguntar o nome da receita
    name = @view.ask_recipe_name
    # 2. Perguntar a descricao da receita
    description = @view.ask_recipe_description
    # 3. Instaciar um objeto recipe
    new_recipe = Recipe.new(name, description)
    # 4. Adicionar o recipe no repository (cookbook)
    @cookbook.add_recipe(new_recipe)
  end

  def destroy
    # 1. Listar todas as receitas com o index
    list
    # 2. Perguntar para o usuário o index da recipe para excluir
    index = @view.ask_recipe_index
    # 3. Remover a receita do repository pelo index
    @cookbook.remove_recipe(index)
  end

  def import
    # 1. Perguntar o ingrediente da receita
    ingredient = @view.ask_ingredient
    # 2. Listar as 5 primeiras receitas do site

    # recipes_from_web é um array de array de 2 elementos, onde o primeiro é o title e o segundo é a URL

    # Por exemplo:
    # [["Easy chocolate fudge cake", "https://www.bbcgoodfood.com/recipes/naughty-chocolate-fudge-cake"],
    #  ["Chocolate marble cake", "https://www.bbcgoodfood.com/recipes/chocolate-marble-cake"],
    #  ["Chocolate fudge crinkle biscuits", "https://www.bbcgoodfood.com/recipes/chocolate-fudge-crinkle-biscuits"],
    #  ["Chocolate sponge cake", "https://www.bbcgoodfood.com/recipes/chocolate-sponge-cake"],
    #  ["Chocolate muffins", "https://www.bbcgoodfood.com/recipes/chocolate-muffins"]]

    recipes_from_web = get_recipes_from_web(ingredient)

    @view.list_recipes_from_web(recipes_from_web)
    # 3. Perguntar o index da receita a ser importada
    index = @view.ask_recipe_index

    url = recipes_from_web[index][1]

    recipe = get_recipe_detail(url)
    @cookbook.add_recipe(recipe)
  end

  private

  def get_recipes_from_web(ingredient)
    url = "https://www.bbcgoodfood.com/search/recipes?q=#{ingredient}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    recipes = []
    html_doc.search('.template-search-universal__card').each do |card|
      title = card.search('a')[1].text.strip
      url = 'https://www.bbcgoodfood.com' + card.search('a')[1].attributes['href'].value
      recipes << [title, url]
    end
    recipes.first(5)
  end

  def get_recipe_detail(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    name = html_doc.search('h1').text
    description = html_doc.search('.editor-content p').text

    return Recipe.new(name, description)
  end


end