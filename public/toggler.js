/* eslint no-unused-vars: */

function toggler (count) {
  'use strict'
  var textArea = document.getElementById('text-area-'.concat(count))
  if (textArea.style.display === 'none') {
    textArea.style.display = 'block'
  } else {
    textArea.style.display = 'none'
  }
}
