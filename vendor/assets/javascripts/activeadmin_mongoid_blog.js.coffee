#= require redactor-rails
#= require select2
#= require activeadmin_reorder_table

$ ->
  # Enable redactor
  $('.redactor').redactor 
    imageUpload:  "/redactor_rails/pictures"
    imageGetJson: "/redactor_rails/pictures"

  # Enable select2
  $('.select2').select2
    minimumResultsForSearch: 10

  tags_input = $("#post_tags")
  if tags_input.length > 0
    tags_url = tags_input.attr("data-url")
    $.get tags_url, (tags) => tags_input.select2({tags: tags })
