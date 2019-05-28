# config/initializers/rspec_api_documentation.rb
RspecApiDocumentation.configure do |config|
  # Output folder
  config.docs_dir = Rails.root.join("doc", "api")

  # An array of output format(s).
  # Possible values are :json, :html, :combined_text, :combined_json,
  #   :json_iodocs, :textile, :markdown, :append_json
  config.format = [:json]
  config.request_body_formatter = :json

  config.request_headers_to_include = %w(Email Password Content-Type)
  config.response_headers_to_include = []

  config.keep_source_order = true
end