/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */
/* eslint no-undef: */

var inputsICC = document.getElementsByClassName('data-icc')

function getIcc () {
  'use strict'
  var keyVars = document.getElementsByClassName('hlm_vars_icc')
  var clusterVal = keyVars[0].options[keyVars[0].selectedIndex].text
  var outcomeVal = keyVars[1].options[keyVars[1].selectedIndex].text
  if (clusterVal === outcomeVal) {
    alert('Cluster variable must be different from outcome variable!')
    return
  } else if (clusterVal === '' || outcomeVal === '') {
    alert('Please selected a variable for cluster and outcome variable!')
    return
  }
  var myResult = new XMLHttpRequest()
  var iccFormData = new FormData()
  var url = '/icc'
  var iccFile = document.getElementById('icc_file')
  var method = document.getElementById('method-icc')
  iccFormData.append(iccFile.name, iccFile.files[0])
  iccFormData.append('method', method.options[method.selectedIndex].value)
  iccFormData.append('clusterVar', clusterVal)
  iccFormData.append('outcomeVar', outcomeVal)
  var data = []
  for (var i = 0; i < keyVars[0].length; i++) {
    data.push(keyVars[0].options[i].text)
  }
  iccFormData.append('data', JSON.stringify(data))
  spinTheWheel('icc-home')
  myResult.open('post', url, true)
  myResult.send(iccFormData)
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-icc')
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
      clearInputs('result-icc')
      var error = myResult.responseText
      result[':warning'].innerText = 'Data entry error: ' + error
    } else {
      clearInputs('result-icc')
      result[':warning'].innerText = 'Something went wrong, please ensure your file is valid.'
    }
    stopTheWheel('icc-home')
  }
}

var idx

function getVariablesICC () {
  'use strict'
  pingPython()
  var calcButton = document.getElementById('icc_btn')
  calcButton.disabled = true
  dieTableICC('model-table-ICC')
  var myResult = new XMLHttpRequest()
  var hlmR2FormData = new FormData()
  var url = '/hlm_r2_parse'
  var iccFile = document.getElementById('icc_file')
  hlmR2FormData.append('file_r2', iccFile.files[0])
  spinTheWheel('icc-home')
  myResult.open('post', url, true)
  myResult.send(hlmR2FormData)
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-icc')
    if (myResult.readyState === 4 && myResult.status === 200) {
      result[':warning'].innerText = ''
      var data = JSON.parse(myResult.responseText)
      var divTable = document.getElementById('outcome-table-ICC')
      divTable.appendChild(createModelTableICC(data))
      calcButton.disabled = false
    } else if (myResult.readyState === 4 && myResult.status === 400) {
      clearInputs('result-icc')
      var error = myResult.responseText
      result[':warning'].innerText = 'Data entry error: ' + error
    } else {
      clearInputs('result-icc')
      result[':warning'].innerText = 'Something went wrong, please ensure your file is valid.'
    }
    stopTheWheel('icc-home')
  }
}

function createModelTableICC (data) {
  var modelTable = document.createElement('table')
  modelTable.id = 'model-table-ICC'
  modelTable.setAttribute('cellpadding', '10')
  modelTable.setAttribute('border', '1')
  if (data.length > 0) {
    var tr = modelTable.insertRow(0)
    var tdZero = tr.insertCell(0)
    clusterNode = document.createTextNode('Cluster variable: ')
    outcomeNode = document.createTextNode('Outcome variable: ')
    tdZero.appendChild(clusterNode)
    tdZero.appendChild(keySelectsICC(data, 'clusterVarICC'))
    tdZero.appendChild(outcomeNode)
    tdZero.appendChild(keySelectsICC(data, 'outcomeVarICC'))
  }
  return modelTable
}

function keySelectsICC (data, id) {
  var reqSelect = document.createElement('SELECT')
  reqSelect.id = id
  reqSelect.name = id
  reqSelect.className = 'hlm_vars_icc'
  reqSelect.required = true
  reqSelect.tabIndex = '6'
  var nullOption = document.createElement('option')
  nullOption.text = ''
  nullOption.value = null
  reqSelect.add(nullOption, 0)
  for (var variable in data) {
    var option = document.createElement('option')
    option.text = data[variable]
    option.value = variable
    reqSelect.add(option, variable + 1)
  }
  return reqSelect
}

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

function pingPython () {
  'use strict'
  // new Image().src = 'https://pythonworkerhlm.appspot.com/'
}

function dieTableICC (id) {
  var dieTable = document.getElementById(id)
  if (dieTable) { dieTable.remove() }
}
