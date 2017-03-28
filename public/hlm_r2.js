// TODO: ENSURE YOU USE ACTUAL HLM DATASET
// TODO: Cluster must not equal Outcome
// TODO: Cluster and outcome must not reappear in analysis
// TODO: Have all data, uses more hashes, validate hashes!

/* jslint browser:true */
/* jslint forin:true */
/* global XMLHttpRequest */
/* eslint no-unused-vars: */
/* eslint no-undef: */

var inputsHLMData = document.getElementsByClassName('data-hlm-r2')
var data

function getHLMR2 () {
  'use strict'
  var myResult = new XMLHttpRequest()
  var hlmR2FormData = new FormData()
  var url = '/hlm_r2'
  var hlmR2File = document.getElementById('file_r2')
  var method = document.getElementById('method-r2')
  method = method.options[method.selectedIndex].value
  var clusterVar = document.getElementById('clusterVar')
  clusterVar = clusterVar.options[clusterVar.selectedIndex].text
  var outcomeVar = document.getElementById('outcomeVar')
  outcomeVar = outcomeVar.options[outcomeVar.selectedIndex].text
  var interceptCenters = document.getElementsByClassName('hlm_table_center_intercept')
  var interceptPredictors = [[], []]
  for (var i = 0; i < interceptCenters.length; i++) {
    if (interceptCenters[i].options[interceptCenters[i].selectedIndex].value !== 'null') {
      interceptPredictors[0].push(interceptCenters[i].id.replace('hlm_table_select_center_level_two_', ''))
      interceptPredictors[1].push(parseInt(interceptCenters[i].options[interceptCenters[i].selectedIndex].value))
    }
  }
  var levelOneCenters = document.getElementsByClassName('hlm_table_center')
  console.log(levelOneCenters.length)
  var levelOneHash = {}
  for (var j = 0; j < levelOneCenters.length; j++) {
    var levelOneName = levelOneCenters[j].id.replace('hlm_table_select_center_', '')
    var slopeCenters = document.getElementsByClassName('hlm_table_center_'.concat(levelOneName))
    var levelOnePreds = [[], []]
    for (var k = 0; k < slopeCenters.length; k++) {
      if (slopeCenters[k].options[slopeCenters[k].selectedIndex].value !== 'null') {
        levelOnePreds[0].push(slopeCenters[k].id.replace('hlm_table_select_center_level_two_', ''))
        levelOnePreds[1].push(parseInt(slopeCenters[k].options[slopeCenters[k].selectedIndex].value))
      }
    }
    levelOneHash[levelOneName] = [levelOnePreds, levelOneCenters[j].selectedIndex]
  }
  var variablesForServer = [method, clusterVar, outcomeVar, interceptPredictors, levelOneHash]
  console.log(variablesForServer)
  hlmR2FormData.append(hlmR2File.name, hlmR2File.files[0])
  hlmR2FormData.append('method', method)
  hlmR2FormData.append('clusterVar', clusterVar)
  hlmR2FormData.append('outcomeVar', outcomeVar)
  hlmR2FormData.append('interceptPredictors', JSON.stringify(interceptPredictors))
  hlmR2FormData.append('levelOneHash', JSON.stringify(levelOneHash))
  hlmR2FormData.append('data', JSON.stringify(data))
  spinTheWheel('r2-home')
  myResult.open('post', url, true)
  myResult.send(hlmR2FormData)
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-hlm-r2')
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
      clearInputs('result-hlm-r2')
      var error = myResult.responseText
      result[':warning'].innerText = 'Data entry error: ' + error
    } else {
      clearInputs('result-hlm-r2')
      result[':warning'].innerText = 'Something went wrong, please ensure your file is valid.'
    }
    stopTheWheel('r2-home')
  }
}

var idx

function hlmR2BtnClick () {
  for (idx = 0; idx < inputsHLMData.length; idx += 1) {
    var inputHLMData = inputsHLMData[idx]
    if (inputHLMData.checkValidity() === false) {
      var inputs = document.getElementById('icc_inputs')
      var warning = document.getElementById('icc_warning')
      var result = document.getElementsByClassName('result-hlm-r2')
      inputs.innerHTML = ''
      warning.innerHTML = 'For '.concat(inputHLMData.name, ': ', inputHLMData.validationMessage)
      for (var i = 0; i < result.length; i++) {
        result[i].value = ''
      }
      return
    }
  }
  clearInputs('result-hlm-r2')
  getHLMR2()
}

function clearInputs (className) {
  var inputs = document.getElementsByClassName(className)
  for (var i = 0; i < inputs.length; i++) {
    var input = inputs[i]
    if (i === 0) input.focus()
    input.value = ''
  }
}

function getVariables () {
  'use strict'
  pingPython()
  var calcButton = document.getElementById('hlm_r2_btn')
  calcButton.disabled = true
  dieTable('model-table')
  dieTable('variable-table')
  dieTable('clusOutButton')
  dieTable('selectPredictorsButton')
  dieTable('spec-table')
  var myResult = new XMLHttpRequest()
  var hlmR2FormData = new FormData()
  var url = '/hlm_r2_parse'
  var hlmR2File = document.getElementById('file_r2')
  hlmR2FormData.append(hlmR2File.name, hlmR2File.files[0])
  spinTheWheel('r2-home')
  myResult.open('post', url, true)
  myResult.send(hlmR2FormData)
  myResult.onreadystatechange = function () {
    var result = document.getElementsByClassName('result-hlm-r2')
    if (myResult.readyState === 4 && myResult.status === 200) {
      result[':warning'].innerText = ''
      data = JSON.parse(myResult.responseText)
      var divTable = document.getElementById('outcome-table')
      divTable.appendChild(createModelTable(data))
      divTable.appendChild(buttonClusterOutcome(data))
    } else if (myResult.readyState === 4 && myResult.status === 400) {
      clearInputs('result-hlm-r2')
      var error = myResult.responseText
      result[':warning'].innerText = 'Data entry error: ' + error
    } else {
      clearInputs('result-hlm-r2')
      result[':warning'].innerText = 'Something went wrong, please ensure your file is valid.'
    }
    stopTheWheel('r2-home')
  }
}

function createModelTable (data) {
  var modelTable = document.createElement('table')
  modelTable.id = 'model-table'
  modelTable.setAttribute('cellpadding', '10')
  modelTable.setAttribute('border', '1')
  if (data.length > 0) {
    var tr = modelTable.insertRow(0)
    var tdZero = tr.insertCell(0)
    clusterNode = document.createTextNode('Cluster variable: ')
    outcomeNode = document.createTextNode('Outcome variable: ')
    tdZero.appendChild(clusterNode)
    tdZero.appendChild(keySelects(data, 'clusterVar'))
    tdZero.appendChild(outcomeNode)
    tdZero.appendChild(keySelects(data, 'outcomeVar'))
  }
  return modelTable
}

function keySelects (data, id) {
  var reqSelect = document.createElement('SELECT')
  reqSelect.id = id
  reqSelect.name = id
  reqSelect.className = 'hlm_vars'
  reqSelect.required = true
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

function buttonClusterOutcome (data) {
  'use strict'
  var clusOutButton = document.createElement('button')
  clusOutButton.id = 'clusOutButton'
  clusOutButton.innerText = 'Select cluster and outcome variables'
  clusOutButton.onclick = changeClusOutButton
  return clusOutButton
}

function changeClusOutButton () {
  'use strict'
  var calcButton = document.getElementById('hlm_r2_btn')
  calcButton.disabled = true
  var keyVars = document.getElementsByClassName('hlm_vars')
  var clusterVal = keyVars[0].options[keyVars[0].selectedIndex].text
  var outcomeVal = keyVars[1].options[keyVars[1].selectedIndex].text
  if (clusterVal === outcomeVal) {
    alert('Cluster variable must be different from outcome variable!')
    return
  }
  var varTable = document.getElementById('variable-table')
  dieTable('variable-table')
  dieTable('selectPredictorsButton')
  dieTable('spec-table')
  var inputs = document.getElementById('hlm_r2_inputs')
  var warning = document.getElementById('hlm_r2_warning')
  var result = document.getElementsByClassName('result-hlm-r2')
  for (var i = 0; i < keyVars.length; i++) {
    var keyVar = keyVars[i]
    if (keyVar.selectedIndex === 0) {
      inputs.innerHTML = ''
      warning.innerHTML = ''
      for (var j = 0; j < result.length; j++) {
        result[j].value = ''
      }
      alert('For '.concat(keyVar.name, ': Please select a variable'))
      return
    }
    inputs.innerHTML = ''
    warning.innerHTML = ''
  }
  var dropVars = [clusterVal, outcomeVal]
  var predictors = []
  for (var k = 0; k < data.length; k++) {
    if (data[k] !== dropVars[0] && data[k] !== dropVars[1]) { predictors.push(data[k]) }
  }
  var divTable = document.getElementById('outcome-table')
  if (predictors.length === 0) {
    alert('You need more additional variables to employ as predictors.')
    return
  }
  divTable.appendChild(createVarTable(predictors))
  divTable.appendChild(selectPredictors())
}

function createVarTable (predictors) {
  var outcomeTable = document.createElement('table')
  outcomeTable.id = 'variable-table'
  outcomeTable.setAttribute('cellpadding', '10')
  outcomeTable.setAttribute('border', '1')
  if (predictors.length > 0) {
    var header = outcomeTable.createTHead()
    var row = header.insertRow(0)
    for (var i = 0; i < 2; i++) {
      var cell = row.insertCell(i)
      if (i === 0) { cell.innerText = 'Variable' }
      if (i === 1) { cell.innerText = 'Role in analysis' }
    }
    for (var variable in predictors) {
      var tr = outcomeTable.insertRow()
      var tdZero = tr.insertCell(0)
      var tdOne = tr.insertCell(1)
      tdZero.appendChild(document.createTextNode(predictors[variable]))
      tdOne.appendChild(variableType(predictors[variable]))
    }
  }
  return outcomeTable
}

function variableType (name) {
  'use strict'
  var id = 'hlm_table_select_'.concat(name)
  var varRole = document.createElement('SELECT')
  varRole.id = id
  varRole.className = 'hlm_table_select'
  var options = ['', 'Level-one predictor', 'Level-two predictor']
  for (var i = 0; i < options.length; i++) {
    var option = document.createElement('option')
    option.text = options[i]
    option.value = i
    varRole.add(option, i)
  }
  return varRole
}

function selectPredictors () {
  'use strict'
  var selectPredictorsButton = document.createElement('button')
  selectPredictorsButton.id = 'selectPredictorsButton'
  selectPredictorsButton.innerText = 'Select level-one and level-two predictors'
  selectPredictorsButton.onclick = aDifficultFunction
  return selectPredictorsButton
}

function aDifficultFunction () {
  'use strict'
  var calcButton = document.getElementById('hlm_r2_btn')
  calcButton.disabled = true
  dieTable('spec-table')
  var selects = document.getElementsByClassName('hlm_table_select')
  var levelOnePredictors = []
  var levelTwoPredictors = []
  for (var i = 0; i < selects.length; i++) {
    if (selects[i].selectedIndex === 1) {
      levelOnePredictors.push(selects[i].id.replace('hlm_table_select_', ''))
    } else if (selects[i].selectedIndex === 2) {
      levelTwoPredictors.push(selects[i].id.replace('hlm_table_select_', ''))
    }
  }
  if (levelOnePredictors.length === 0 && levelTwoPredictors.length === 0) {
    alert('Predictors required to calculate Pseudo R-squared')
    return
  }
  var predictors = [levelOnePredictors, levelTwoPredictors]
  var divTable = document.getElementById('outcome-table')
  divTable.appendChild(specTable(predictors))
  calcButton.disabled = false
}

function specTable (predictors) {
  'use strict'
  var specTable = document.createElement('table')
  var levelOne = predictors[0]
  var levelTwo = predictors[1]
  specTable.id = 'spec-table'
  specTable.setAttribute('cellpadding', '10')
  specTable.setAttribute('border', '1')
  var header = specTable.createTHead()
  var row = header.insertRow(0)
  for (var i = 0; i < 2; i++) {
    var cell = row.insertCell(i)
    if (i === 0) { cell.innerText = 'Intercepts, level-one slopes & centering of level-one predictor' }
    if (i === 1) { cell.innerText = 'Level-two predictors' }
  }
  var tr = specTable.insertRow()
  var tdZero = tr.insertCell(0)
  tdZero.style.textAlign = 'right'
  var tdOne = tr.insertCell(1)
  tdZero.appendChild(document.createTextNode('Intercept: '))
  for (var j = 0; j < levelTwo.length; j++) {
    tdOne.appendChild(centeringTwo(levelTwo[j], 'intercept'))
  }
  for (var variable in levelOne) {
    tr = specTable.insertRow()
    tdZero = tr.insertCell(0)
    tdZero.style.textAlign = 'right'
    tdZero.appendChild(document.createTextNode(levelOne[variable].concat(': ')))
    tdZero.appendChild(centering(levelOne[variable]))
    tdOne = tr.insertCell(1)
    for (var k = 0; k < levelTwo.length; k++) {
      tdOne.appendChild(centeringTwo(levelTwo[k], levelOne[variable]))
    }
  }
  return specTable
}

function centering (name) {
  var id = 'hlm_table_select_center_'.concat(name)
  var varCentering = document.createElement('SELECT')
  varCentering.id = id
  varCentering.className = 'hlm_table_center'
  var options = ['No-centering', 'Group-mean centering', 'Grand-mean centering']
  for (var i = 0; i < options.length; i++) {
    var option = document.createElement('option')
    option.text = options[i]
    option.value = i
    varCentering.add(option, i)
  }
  return varCentering
}

function centeringTwo (name, owner) {
  var id = 'hlm_table_select_center_level_two_'.concat(name)
  var varCentering = document.createElement('SELECT')
  varCentering.id = id
  varCentering.className = 'hlm_table_center_'.concat(owner)
  var options = ['No-centering', 'Grand-mean-centering']
  var option = document.createElement('option')
  option.text = ''
  option.value = null
  varCentering.add(option, i)
  for (var i = 0; i < options.length; i++) {
    option = document.createElement('option')
    option.text = name.concat(' - ', options[i])
    name.concat('-', options[i])
    if (i === 0) {
      option.value = i
    } else { option.value = i + 1 }
    varCentering.add(option, i + 1)
  }
  return varCentering
}

function dieTable (id) {
  var dieTable = document.getElementById(id)
  if (dieTable) { dieTable.remove() }
}
