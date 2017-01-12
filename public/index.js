/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */

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
          result[names[i]].innerText = 'Inputs: '.concat(JSON.stringify(data[names[i]]))
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
          result[names[i]].innerText = 'Inputs: '.concat(JSON.stringify(data[names[i]]))
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
        if (names[i] !== ':inputs') {
          result[names[i]].value = data[names[i]]
        }
      }
    } else if (myResult.readyState === 4 && myResult.status === 400) {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
      }
    } else {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
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
        if (names[i] !== ':inputs') {
          result[names[i]].value = data[names[i]]
        }
      }
    } else if (myResult.readyState === 4 && myResult.status === 400) {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
      }
    } else {
      for (i = 0; i < result.length; i++) {
        result[i].value = ''
      }
    }
  }
}

var idx

for (idx = 0; idx < inputsOneSample.length; idx += 1) {
  var inputOne = inputsOneSample[idx]
  inputOne.addEventListener('input', getOneSample)
}

for (idx = 0; idx < inputsIndSample.length; idx += 1) {
  var inputInd = inputsIndSample[idx]
  inputInd.addEventListener('input', getIndSample)
}

for (idx = 0; idx < inputsRmSample.length; idx += 1) {
  var inputRm = inputsRmSample[idx]
  inputRm.addEventListener('input', getRmSample)
}

for (idx = 0; idx < inputsAvSample.length; idx += 1) {
  var inputAv = inputsAvSample[idx]
  inputAv.addEventListener('input', getAvSample)
}
