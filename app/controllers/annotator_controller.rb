# Controller and API for Catalyst annotators
class AnnotatorController < ApplicationController
  include FormatCatalystRequest
  include ManageAnnotatorRecipeUpdates
  
  # Create a new recipe
  def create_annotator
    annotator = Annotator.new
    annotator.parse_config(params['annotator'], params['recipe_id'])
    annotator.save
  end

  # Update the annotator given the ID
  def update_annotator
    annotator = Annotator.find(params["annotator_id"])
    
    # Check which fields have been changed
    updated = JSON.parse(params['updated_annotator'])
    changed_fields = check_changed_fields(annotator, updated)
    
    # Save annotator
    annotator.update(JSON.parse(params["updated_annotator"]))
    annotator.save
  end

  # Delete an annotator given the id
  def destroy_annotator
    annotator = Annotator.find(params["annotator_id"])
    remove_param_and_destroy_annotator(annotator)
  end

  # Get all the annotators matching a certain recipe
  def get_annotators_for_recipe
    recipe_name = params["recipe_name"]
    matching = Recipe.find_by(title: recipe_name)
    render json: matching.annotators.to_json
  end
end
