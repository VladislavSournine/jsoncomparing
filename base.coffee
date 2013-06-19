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

zKey = (object) ->
	result = null
	if (not _.isArray object) and (not _.isObject object)
		return object
	if _.isArray object
		for i in [0...object.length]
			object[i] = zKey object[i]
		result = []
		for k in [0...object.length]
			if k > 0
				check = false
				for i in [0...k]
					if _.isEqual(object[k],object[i])
						check = true
						break
				if not check
					for l,p of object[k]
						if _.isArray p
							p = zKey p
							break
						if p != object[k-1][l]
							t = []
							t.push object[k-1][l]
							t.push p
							object[k-1][l] = t
					result.push object[k]
					break
			else
				result.push object[k]
		result = result.splice(0,1)
	else
		for k,v of object
			object[k] = zKey object[k]
		result = object
	return result


allKey = (object) ->
	result = null
	if _.isArray object
		if object.length == 0
			return "[]"
		result = []
		for k,v of object
			if (_.isObject v) and (not v.length) and (v != null)
				subObject = allKey v
				if k > 0 and result[k-1]
					alreadyPresentInArray = false
					l = 0
					for l in [0...k]
						if _.isEqual(result[l],subObject)
							alreadyPresentInArray = true
							break
					if not alreadyPresentInArray
						result[k] = subObject
				else
					result[k] = subObject
			else
				result.push typeof v
		result = _.uniq result
	if (_.isObject object) and (not object.length)
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
	return result

compare = (object,etalon,result) ->
	for k,v of object
		if _.isArray etalon[k]
			for s,i of etalon[k]
				if _.isObject i
					i = compare(i,etalon[k][0],result)
					break 
				if etalon[k].indexOf(i) < 0
					object[k][s] = '<strong>'+i+'</strong>'
					result.push k+':'+i

		else
			if _.isObject etalon[k]
				tempo_result = compare v,etalon[k],result
				if tempo_result.length > 0
					result.push tempo_result
			else
				if v != etalon[k]
					object[k] = '<strong>'+v+'</strong>'
					if _.isArray v
						v = _.uniq v
						result.push k+': Array of ['+v[0]+']'
					else
						result.push k+':'+v
	return object

jQuery ->
	poster '/source.json','GET','json',{},(data) ->
		etalonJS = zKey allKey(data)
		$("#etalon").html JSON.stringify etalonJS

	$("#checkgood").on click: ->
		poster '/goodcheck.json','GET','json',{},(data) ->
			testJS = zKey allKey(data)
			$("#forcheck").html JSON.stringify testJS
			result = []
			$("#result").html JSON.stringify compare testJS,etalonJS,result
			console.log result

	$("#checkbad").on click: ->
		poster '/badcheck.json','GET','json',{},(data) ->
			testJS =  zKey allKey(data)
			$("#forcheck").html JSON.stringify testJS
			result = []
			$("#result").html JSON.stringify compare testJS,etalonJS,result
			console.log result

