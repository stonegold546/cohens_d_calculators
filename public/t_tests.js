/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */

var inputsOneSample = document.getElementsByClassName('data-one-sample')
var inputsIndSample = document.getElementsByClassName('data-ind-sample')
var inputsRmSample = document.getElementsByClassName('data-rm-sample')
var inputsAvSample = document.getElementsByClassName('data-av-sample')

function getOneSample () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/one_sample_t?'
  for (var i = 0; i < inputsOneSample.length; i++) {
    if (inputsOneSample[i].value !== '') {
      url = url.concat(inputsOneSample[i].name, '=', inputsOneSample[i].value, '&')
    }
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-one-sample')
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

function getIndSample () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/independent_samples_t?'
  for (var i = 0; i < inputsIndSample.length; i++) {
    if (inputsIndSample[i].value !== '') {
      url = url.concat(inputsIndSample[i].name, '=', inputsIndSample[i].value, '&')
    }
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-ind-sample')
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

function getRmSample () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/dependent_samples_t_repeated?'
  for (var i = 0; i < inputsRmSample.length; i++) {
    if (inputsRmSample[i].value !== '') {
      url = url.concat(inputsRmSample[i].name, '=', inputsRmSample[i].value, '&')
    }
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-rm-sample')
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

function getAvSample () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/dependent_samples_t_average?'
  for (var i = 0; i < inputsAvSample.length; i++) {
    if (inputsAvSample[i].value !== '') {
      url = url.concat(inputsAvSample[i].name, '=', inputsAvSample[i].value, '&')
    }
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-av-sample')
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

function oneSampleBtnClick () {
  for (idx = 0; idx < inputsOneSample.length; idx += 1) {
    var inputOne = inputsOneSample[idx]
    if (inputOne.name === 'n' && inputOne.value === '') {
    } else if (inputOne.checkValidity() === false) {
      var inputs = document.getElementById('one_sample_inputs')
      var warning = document.getElementById('one_sample_warning')
      var result = document.getElementsByClassName('result-one-sample')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputOne.name, ': ', inputOne.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  getOneSample()
}

function indSampleBtnClick () {
  for (idx = 0; idx < inputsIndSample.length; idx += 1) {
    var inputInd = inputsIndSample[idx]
    if (inputInd.checkValidity() === false) {
      var inputs = document.getElementById('ind_sample_inputs')
      var warning = document.getElementById('ind_sample_warning')
      var result = document.getElementsByClassName('result-ind-sample')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputInd.name, ': ', inputInd.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  getIndSample()
}

function depSampleBtnClick () {
  doAv()
  doRm()
}

function doAv () {
  for (idx = 0; idx < inputsAvSample.length; idx += 1) {
    var inputOne = inputsAvSample[idx]
    if (inputOne.checkValidity() === false) {
      var inputs = document.getElementById('av_sample_inputs')
      var warning = document.getElementById('av_sample_warning')
      var result = document.getElementsByClassName('result-av-sample')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputOne.name, ': ', inputOne.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  getAvSample()
}

function doRm () {
  for (idx = 0; idx < inputsRmSample.length; idx += 1) {
    var inputOne = inputsRmSample[idx]
    if (inputOne.checkValidity() === false) {
      var inputs = document.getElementById('rm_sample_inputs')
      var warning = document.getElementById('rm_sample_warning')
      var result = document.getElementsByClassName('result-rm-sample')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputOne.name, ': ', inputOne.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  getRmSample()
}

function clearInputs (className) {
  var inputs = document.getElementsByClassName(className)
  for (var i = 0; i < inputs.length; i++) {
    var input = inputs[i]
    if (i === 0) input.focus()
    input.value = ''
  }
}

// if (inputOne.name === 'n_pairs' && inputOne.value === '') {
