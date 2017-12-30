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

  addUserInput = document.querySelector('#username')

  $('#username').on 'keyup', ->
    username = $('#username').val()
    $.ajax
      type: 'GET'
      url: "/users/search/#{username}"
      success: (data) ->
        console.log data 
