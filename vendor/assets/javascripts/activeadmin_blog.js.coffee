#= require activeadmin_reorder_table
#= require activeadmin_settings

if !Array.prototype.last
  Array.prototype.last = () -> return this[this.length - 1]

enable_collapsable_details = ->
  $('.collapsed .collapse-button-show').live 'click', (e) ->
    e.preventDefault()
    $(this).closest('.collapsed').removeClass('collapsed')

  $('form .collapse-button-hide').click (e) ->
    e.preventDefault()
    $(this).closest('fieldset').addClass('collapsed')

enable_header_link_highlight = ->
  if $('.admin_categories').length > 0
    $('#header #blog').addClass("current")

enable_redactor = ->
  $('.redactor').redactor()

enable_select2 = ->
  $('.select2').select2
    minimumResultsForSearch: 10

  tags_input = $("#post_tags")
  
  if tags_input.length > 0
    tags_url = tags_input.attr("data-url")
    $.get tags_url, (tags) => tags_input.select2({tags: tags })

categories_reorder = ->
  categories_sortable_options = (url) ->
    options =
      stop: (e, ui) ->
        # Select object ids from the table rows
        # -------------------------------------
        ids = []                
        $(this).find('li').each ->
          id_attr = $(this).attr('id')
          if id_attr
            id      = id_attr.split("_").last()
            ids.push(id)
        
        params =
          ids:                ids
          _method:            "put"
          authenticity_token: $('meta[name=csrf-token]').attr('content')
        
        $.post url, params, (data) ->
          if data != "ok"
            alert 'Error happended. Please contact devs.'
    return options

  reorder_method_url = "/admin/categories/reorder"
  $("#blog_categories_list")
    .sortable(categories_sortable_options(reorder_method_url))
    .disableSelection()


$ ->
  enable_collapsable_details()
  enable_header_link_highlight()
  enable_redactor()
  #enable_select2()
  categories_reorder()
