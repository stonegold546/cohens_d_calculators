/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */
/* eslint no-undef: */

var inputsOddsRatio = document.getElementsByClassName('data-odds-ratio')

function getOddsRatio () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/odds?'
  for (var i = 0; i < inputsOddsRatio.length; i++) {
    if (inputsOddsRatio[i].id === 'method-odds') {
      var method = inputsOddsRatio[i]
      url = url.concat('method=', method.options[method.selectedIndex].value, '&')
    } else if (inputsOddsRatio[i].value !== '') {
      url = url.concat(inputsOddsRatio[i].name, '=', inputsOddsRatio[i].value, '&')
    }
  }
  spinTheWheel('odds-home')
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-odds-ratio')
    if (myResult.readyState === 4 && myResult.status === 200) {
      result[':warning'].innerText = ''
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
      clearInputs('result-odds-ratio')
      var error = myResult.responseText
      result[':warning'].innerText = 'Data entry error: ' + error
    } else {
      clearInputs('result-odds-ratio')
      result[':warning'].innerText = 'Something went wrong.'
    }
    stopTheWheel('odds-home')
  }
}

var idx

function oddsRatioBtnClick () {
  for (idx = 0; idx < inputsOddsRatio.length; idx += 1) {
    var inputOdds = inputsOddsRatio[idx]
    if (inputOdds.checkValidity() === false) {
      var inputs = document.getElementById('odds_ratio_inputs')
      var warning = document.getElementById('odds_ratio_warning')
      var result = document.getElementsByClassName('result-odds-ratio')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputOdds.name, ': ', inputOdds.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  clearInputs('result-odds-ratio')
  getOddsRatio()
}

function clearInputs (className) {
  var inputs = document.getElementsByClassName(className)
  for (var i = 0; i < inputs.length; i++) {
    var input = inputs[i]
    if (i === 0) input.focus()
    input.value = ''
  }
}
