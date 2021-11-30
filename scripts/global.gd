extends Node

onready var screen_size := get_viewport().size

var font: DynamicFont

var screen = 'StartScreen'

func _ready():
	font = DynamicFont.new()
	font.font_data = load('res://Connection.otf')
	font.size = 20
	font.use_filter = false

	call_deferred('load_state')

func load_state():
	var file := File.new()
	var error := file.open('user:/state.json', File.READ)
	if not error:
		pass
	elif error == ERR_FILE_NOT_FOUND:
		change_screen('HelloWorld')
	else:
		printerr("Error loading state.")
		get_tree().quit()

func change_screen(name):
	if get_tree().change_scene('res://scenes/%s.tscn' % name):
		printerr("Broken screen transition from %s to %s" % [screen, name])
	screen = name
