/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */

var inputsFixedEffects = document.getElementsByClassName('data-fixed-effects')

function getFixedEffects () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/fixed_effects?'
  for (var i = 0; i < inputsFixedEffects.length; i++) {
    if (inputsFixedEffects[i].value !== '') {
      url = url.concat(inputsFixedEffects[i].name, '=', inputsFixedEffects[i].value, '&')
    }
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-fixed-effects')
    if (myResult.readyState === 4 && myResult.status === 200) {
      var data = JSON.parse(myResult.responseText)
      var names = Object.keys(data)
      for (var i = 0; i < names.length; i++) {
        if (names[i] === ':inputs') {
          result[names[i]].innerText = 'Entered values: '.concat(JSON.stringify(data[names[i]], null, 1))
        } else if (names[i] === ':warning') {
          result[names[i]].innerText = data[names[i]]
        } else {
          result[names[i]].value = data[names[i]]
        }
      }
    } else if (myResult.readyState === 4 && myResult.status === 400) {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
        result[i].innerText = ''
      }
      var error = myResult.responseText
      result[':inputs'].innerText = 'Data entry error: ' + error
    } else {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
        result[i].innerText = ''
      }
    }
  }
}

var idx

function fixedEffectsBtnClick () {
  for (idx = 0; idx < inputsFixedEffects.length; idx += 1) {
    var inputFixed = inputsFixedEffects[idx]
    if (inputFixed.checkValidity() === false) {
      var inputs = document.getElementById('fixed_effects_inputs')
      var warning = document.getElementById('fixed_effects_warning')
      var result = document.getElementsByClassName('result-fixed-effects')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputFixed.name, ': ', inputFixed.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  getFixedEffects()
}

function clearInputs (className) {
  var inputs = document.getElementsByClassName(className)
  for (var i = 0; i < inputs.length; i++) {
    var input = inputs[i]
    if (i === 0) input.focus()
    input.value = ''
  }
}
