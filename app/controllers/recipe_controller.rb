# Controller and API for Catalyst recipes
class RecipeController < ApplicationController
  include FormatCatalystRequest
  include RunCatalyst
  
  # Run a recipe
  def run_recipe
    recipe_to_run = Recipe.find(params["recipe_id"])

    # ormat the recipe and docs to process
    docs_to_process = recipe_to_run.docs_to_process
    index = recipe_to_run.index_name
    default_dataspec = recipe_to_run.doc_type
    input_params = format_annotator_list(recipe_to_run)
    
    # Run Catalyst
    run_catalyst(index, default_dataspec, docs_to_process, input_params)
  end

  # Update the recipe given the ID
  def update_recipe
    recipe = Recipe.find(params["recipe_id"])
    recipe.update(JSON.parse(params["updated_recipe"]))
    recipe.save
  end
  
  # Create a new recipe
  def create_recipe
    recipe = Recipe.new
    recipe.parse_config(params['recipe'])
    recipe.save
    render json: recipe.id
  end

  # Delete a recipe given the id
  def destroy_recipe
    recipe = Recipe.find(params["recipe_id"])
    recipe.annotators.each{|annotator| remove_param_and_destroy_annotator(annotator) }
    recipe.destroy
  end

  # Get all the recipes for a project (based on index name)
  def get_recipes_for_index
    index = params["index_name"]
    matching = Recipe.where(index_name: index)
    render json: matching.to_json
  end
end
