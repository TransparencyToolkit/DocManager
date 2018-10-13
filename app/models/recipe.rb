# Recipes group together multiple annotators for Catalyst and set the index, document type, and in some cases subset of documents the annotators should be run over
class Recipe < ApplicationRecord
  include SetFields
  
  has_many :annotators
  belongs_to :project
  validates :title, uniqueness: true
  validates_presence_of :title,
                        :docs_to_process,
                        :index_name,
                        :doc_type

  # Load in the config file
  def parse_config(config_json)
    source_config = JSON.parse(config_json)
    load_fields(source_config)
    matching_project = Project.where(index_name: self.index_name).first
    self.project = matching_project
    return self
  end
end
