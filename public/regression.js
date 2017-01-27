/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */

var inputsRegression = document.getElementsByClassName('data-ols')

function getOls () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/ols_r2?'
  for (var i = 0; i < inputsRegression.length; i++) {
    if (inputsRegression[i].value !== '') {
      url = url.concat(inputsRegression[i].name, '=', inputsRegression[i].value, '&')
    }
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-ols')
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
    } else {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
        result[i].innerText = ''
      }
    }
  }
}

var idx

function olsBtnClick () {
  for (idx = 0; idx < inputsRegression.length; idx += 1) {
    var inputOls = inputsRegression[idx]
    if (inputOls.checkValidity() === false) {
      var inputs = document.getElementById('ols_inputs')
      var warning = document.getElementById('ols_warning')
      var result = document.getElementsByClassName('result-ols')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputOls.name, ': ', inputOls.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  getOls()
}

function clearInputs (className) {
  var inputs = document.getElementsByClassName(className)
  for (var i = 0; i < inputs.length; i++) {
    var input = inputs[i]
    if (i === 0) input.focus()
    input.value = ''
  }
}
