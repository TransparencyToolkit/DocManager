# Runs the Catalyst request
module RunCatalyst
  def run_catalyst(index_name, default_dataspec, docs_to_process, annotators_to_run)
    Thread.new do
      c = Curl::Easy.http_post("#{ENV['CATALYST_URL']}/annotate",
                               Curl::PostField.content('default_dataspec', default_dataspec),
                               Curl::PostField.content('index', index_name),
                               Curl::PostField.content('docs_to_process', JSON.generate(docs_to_process)),
                               Curl::PostField.content('input-params', JSON.generate(annotators_to_run)))
    end
  end
end
