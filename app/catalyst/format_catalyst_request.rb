# Format a particular recipe to run
module FormatCatalystRequest
  include ModifyDatasource
  
  # Set a machine readable param name
  def gen_machine_readable_param(human_readable)
    return "catalyst_"+human_readable.strip.downcase.gsub(" ", "_").gsub("-", "_")
  end

  # Remove a parameter from an annotator that is destroyed
  def remove_param_and_destroy_annotator(annotator)
    annotator_param = gen_machine_readable_param(annotator.human_readable_label)
    remove_field_from_source(annotator_param, annotator.recipe.doc_type, annotator.recipe.index_name)
    annotator.destroy
  end
  
  # Format the list of annotators
  def format_annotator_list(recipe_to_run)
    return recipe_to_run.annotators.map do |annotator|
      annotator_hash = Hash.new
      saved_annotator = JSON.parse(annotator.to_json)
      annotator_hash[:annotator_name] = saved_annotator["annotator_class"]
      annotator_hash[:fields_to_check] = saved_annotator["fields_to_check"]
      annotator_hash[:input_params] = saved_annotator["annotator_options"].symbolize_keys
      annotator_hash[:output_param_name] = saved_annotator["human_readable_label"]
      annotator_hash[:output_param_icon] = saved_annotator["icon"]
      annotator_hash
    end
  end
end
