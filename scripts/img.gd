extends Node2D

var getsheetname = "" # sheet name from where you want to get data 
var apiurl = "https://script.google.com/macros/s/AKfycbzz1wpQuiwJIEj1PHmx59ZteUc5ogP0Ikk88vuxaeKSw8UoWRcGUCycv_Qc9rth5EJC/exec"
var geturl = apiurl+"?sheetname="+getsheetname
var send = ""

func getdata():
	getsheetname = "images"
	geturl = apiurl+"?sheetname="+getsheetname
	$HTTPRequest.request(geturl)


func _ready():
	getdata()
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var data = body.get_string_from_utf8()
	data = parse_json(data)
	print("data: ", data)
	#print(data[1]["FILENAME"])
	print(len(data))
	for i in range(len(data)):
		$imgoptions.add_item(data[i]["FILENAME"])


func _on_code_pressed():
	get_tree().change_scene("res://scenes/dashboard.tscn")


func _on_Button_pressed():
	$MenuButton.visible = true

func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex

func _on_MenuButton_file_selected(path):
	$container/Sprite.texture = load_external_tex(path)
