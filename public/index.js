/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */

var inputsOneSample = document.getElementsByClassName('data-one-sample')
var inputsIndSample = document.getElementsByClassName('data-ind-sample')

function getOneSample () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/one_sample_t?'
  for (var i = 0; i < inputsOneSample.length; i++) {
    url = url.concat(inputsOneSample[i].name, '=', inputsOneSample[i].value, '&')
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-one-sample')
    var innerIdx = 0
    if (myResult.readyState === 4 && myResult.status === 200) {
      var data = JSON.parse(myResult.responseText)
      var cohenDz = ':cohen_dz'
      result[innerIdx].value = data[cohenDz]
    } else if (myResult.readyState === 4 && myResult.status === 400) {
      result[innerIdx].value = ''
    } else {
      result[innerIdx].value = ''
    }
  }
}

function getIndSample () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var url = '/independent_samples_t?'
  for (var i = 0; i < inputsIndSample.length; i++) {
    url = url.concat(inputsIndSample[i].name, '=', inputsIndSample[i].value, '&')
  }
  myResult.open('GET', url, true)
  myResult.send()
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-ind-sample')
    if (myResult.readyState === 4 && myResult.status === 200) {
      var data = JSON.parse(myResult.responseText)
      console.log(data)
      var names = Object.keys(data)
      console.log(names)
      console.log(result)
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
