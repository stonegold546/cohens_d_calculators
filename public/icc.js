/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */

var inputsICC = document.getElementsByClassName('data-icc')

function getIcc () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var iccFormData = new FormData()
  var url = '/icc'
  var iccFile = document.getElementById('icc_file')
  iccFormData.append('file', iccFile.files[0])
  myResult.open('post', url, true)
  myResult.setRequestHeader('Content-Type', 'multipart/form-data')
  myResult.send(iccFormData)
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-icc')
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

function iccBtnClick () {
  for (idx = 0; idx < inputsICC.length; idx += 1) {
    var inputsIcc = inputsICC[idx]
    if (inputsIcc.checkValidity() === false) {
      var inputs = document.getElementById('icc_inputs')
      var warning = document.getElementById('icc_warning')
      var result = document.getElementsByClassName('result-icc')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputsIcc.name, ': ', inputsIcc.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  getIcc()
}

function clearInputs (className) {
  var inputs = document.getElementsByClassName(className)
  for (var i = 0; i < inputs.length; i++) {
    var input = inputs[i]
    if (i === 0) input.focus()
    input.value = ''
  }
}
