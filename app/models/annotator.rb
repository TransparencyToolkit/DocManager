# Model for Catalyst annotators
class Annotator < ApplicationRecord
  include SetFields
  
  belongs_to :recipe

  validates_presence_of :annotator_class,
                        :fields_to_check

  # Load in the config file
  def parse_config(config_json, recipe_id)
    source_config = JSON.parse(config_json)
    load_fields(source_config)
    matching_recipe = Recipe.find(recipe_id)
    self.recipe = matching_recipe
    return self
  end
end
