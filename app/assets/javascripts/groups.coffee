# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # searchUsers: (username) ->
  #   $.ajax
  #     url: "/users/#{username}"
  #     type: 'GET'
  #     success: (data) ->
  #     console.log data

  addUserInput = $('#username')
  searchResultDiv = $('#search-results')

  addUserInput.keyup () ->
    username = addUserInput.val()
    if username.length > 0
      $.ajax
        type: 'GET'
        url: "/users/search/#{username}"
        # success: (users) ->
        #   users.map (user) ->
        #     console.log user.username
        #     return
    else
      searchResultDiv.html('')
