/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */
/* eslint no-undef: */

var inputsICC = document.getElementsByClassName('data-icc')
var spinner = null

function getIcc () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var iccFormData = new FormData()
  var url = '/icc'
  var iccFile = document.getElementById('icc_file')
  var method = document.getElementById('method')
  iccFormData.append(iccFile.name, iccFile.files[0])
  iccFormData.append(method.id, method.options[method.selectedIndex].value)
  var target = document.getElementById('icc-home')
  if (spinner == null) {
    spinner = new Spinner(opts).spin(target)
    console.log(spinner)
  } else {
    spinner.spin(target)
  }
  myResult.open('post', url, true)
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
      var error = myResult.responseText
      result[':inputs'].innerText = 'Data entry error: ' + error
    } else {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
        result[i].innerText = ''
      }
    }
    spinner.stop(target)
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
  clearInputs('result-icc')
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
