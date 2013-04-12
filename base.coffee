etalonJS = null
testJS = null
errorJS = null

poster = (url,type,returned,data,func) ->
  if type == 'GET'
    url = url+"?"+Math.random()
  if !returned
    returned = 'html'
  $.ajax url,
    type : type,
    data : data,
    dataType: returned,
    success : (res,status,xhr) ->
      # console.log 'Done poster with url ',url
      func res if func?
    error : (xhr, status, err) ->
      # console.log "ERROR"
      # console.log xhr,status,err

allKey = (object) ->
  result = null
	if _.isObject object
		result = {}
		for k,v of object
			if _.isObject v or _.isArray v
				subObject = allKey v
				result[k] = subObject
			else
				if v?
					result[k] = typeof v
				else
					result[k] = "null"
	if _.isArray object
		result = []
		for k,v of object
			result.push typeof v
		result = _.uniq result
	return result


compare = (object,etalon) ->
	for k,v of object
		if _.isArray etalon[k]
			for s,i of v
				if etalon[k].indexOf(i) < 0
					object[k][s] = '<strong>*'+i+'</strong>'

		else
			if _.isObject etalon[k]
				tempo_result = compare v,etalon[k]
				if tempo_result.length > 0
					result.push tempo_result
			else
				if v != etalon[k]
					object[k] = '<strong>*'+v+'</strong>'
	return object

jQuery ->
	poster '/source.json','GET','json',{},(data) ->
		etalonJS = allKey(data)
		$("#etalon").html JSON.stringify etalonJS

	$("#checkgood").on click: ->
		poster '/goodcheck.json','GET','json',{},(data) ->
			testJS = allKey(data)
			$("#forcheck").html JSON.stringify testJS
			$("#result").html JSON.stringify compare testJS,etalonJS

	$("#checkbad").on click: ->
		poster '/badcheck.json','GET','json',{},(data) ->
			testJS = allKey(data)
			$("#forcheck").html JSON.stringify testJS
			$("#result").html JSON.stringify compare testJS,etalonJS

