extends Node2D

var getsheetname = "" # sheet name from where you want to get data 
var apiurl = "https://script.google.com/macros/s/AKfycbzz1wpQuiwJIEj1PHmx59ZteUc5ogP0Ikk88vuxaeKSw8UoWRcGUCycv_Qc9rth5EJC/exec"
var geturl = apiurl+"?sheetname="+getsheetname
var data = ""
var send = false
func getdata():
	$textopions.clear()
	send = false
	getsheetname = "code"
	geturl = apiurl+"?sheetname="+getsheetname
	$HTTPRequest.request(geturl)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if send:
		pass
	else:
		data = body.get_string_from_utf8()
		data = parse_json(data)
		for i in range(len(data)):
			$textopions.add_item(data[i]["FILENAME"])


func _ready():
	getdata()


func _on_refcode_pressed():
	getdata()


func _on_images_pressed():
	get_tree().change_scene("res://scenes/img.tscn")


func _on_textopions_item_selected(index):
	#print($textopions.get_item_text(index))
	#$TextEdit.text = data[index]["CONTENT"].replace("RETURNX","\n").replace("SPACEX","	").replace("COLONX",":").replace("COMMAX",",")
	$TextEdit.text = Marshalls.base64_to_raw(data[index]["CONTENT"]).get_string_from_utf8()

	
	#$TextEdit.text = Marshalls.base64_to_raw(data[index]["CONTENT"])

func _on_upload_code_pressed():
	send = true
	var cfilename = $cfilename.text
	var cfilecontent = Marshalls.raw_to_base64($TextEdit.text.to_utf8())
#	var txt = $TextEdit
#	var lines = ""
#	for i in range(txt.get_line_count()):
#		lines = lines + txt.get_line(i)+"RETURNX"
#	print(lines)
	
	#var cfilecontent = lines.replace("	","SPACEX").replace(":","COLONX").replace(",","COMMAX")	
	var datasend = "?cfilename="+cfilename+"&ccontent="+str(cfilecontent) #LOOK into appscript's code doPost func to understand this 
	var headers = ["Content-Length: 0"]
	var posturl = apiurl+datasend
	#print(posturl)
	#print(cfilecontent)
	$HTTPRequest.request(posturl,headers,true,HTTPClient.METHOD_POST)
