# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  if window.location.pathname == '/users'
    a = document.querySelectorAll('ul.nav.nav-tabs li')
    a[1].addEventListener 'click', ->
      if a[0].classList.contains('active')
        a[0].classList.remove 'active'
        a[1].classList.add 'active'
      return
    a[0].addEventListener 'click', ->
      if a[1].classList.contains('active')
        a[1].classList.remove 'active'
        a[0].classList.add 'active'
      return
