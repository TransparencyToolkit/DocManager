require 'curb'
require 'json'

doc_class = "ArchiveTestDoc"
project_index = "archive_test"
field_name = "field_to_add"
field_hash = {
  display_type: "Category",
  icon: "",
  human_readable: "Dynamically Added Field"
}

c = Curl::Easy.new("http://localhost:3000/add_field")
c.http_post(Curl::PostField.content("doc_class", doc_class),
            Curl::PostField.content("project_index", project_index),
            Curl::PostField.content("field_name", field_name),
            Curl::PostField.content("field_hash", JSON.pretty_generate(field_hash)))

json = [
  { field_to_add: "IT WORKS!!!",
    another_field_to_add: ["category 1", "category 2"],
    rel_path: "rel_path_uniq.pdf",
    title: "Title of doc here",
    text: "Doc text"
  }
]
  c = Curl::Easy.new("http://localhost:3000/add_items")
  c.http_post(Curl::PostField.content("item_type", "ArchiveTestDoc"),
              Curl::PostField.content("index_name", "archive_test"),
              Curl::PostField.content("items", JSON.pretty_generate(json)))



  c = Curl::Easy.new("http://localhost:3000/add_field")
  c.http_post(Curl::PostField.content("doc_class", doc_class),
              Curl::PostField.content("project_index", project_index),
              Curl::PostField.content("field_name", "another_field_to_add"),
              Curl::PostField.content("field_hash", JSON.pretty_generate(field_hash)))
  
  c = Curl::Easy.new("http://localhost:3000/remove_field")
  c.http_post(Curl::PostField.content("doc_class", doc_class),
              Curl::PostField.content("project_index", project_index),
              Curl::PostField.content("field_name", "field_to_add"))
