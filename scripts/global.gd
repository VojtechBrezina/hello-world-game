extends Node

onready var screen_size := get_viewport().size

var font: DynamicFont

var screen = 'StartScreen'

var global_state := {}

func _ready():
	font = DynamicFont.new()
	font.font_data = load('res://Connection.otf')
	font.size = 20
	font.use_filter = false

	call_deferred('load_state')

func _notification(what: int):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		call_deferred('save_state', true)

func load_state():
	var file := File.new()
	var error := file.open('user://state.json', File.READ)
	if not error:
		var data: Dictionary = JSON.parse(file.get_as_text()).result
		get_tree().call_group('state', 'state_load', data)
		file.close()
	elif error == ERR_FILE_NOT_FOUND:
		change_screen('HelloWorld')
	else:
		printerr("Error loading state.")
		get_tree().quit()

		
		
func save_state(quit: bool = false):
	var file := File.new()
	var data = {}
	
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, 'state', 'state_save', data)
	
	if !file.open('user://state.json', File.WRITE):
		get_tree().quit()
		file.store_string(JSON.print(data))
		file.close()
	else:
		printerr("Error saving state.")
		
	if quit:
		get_tree().quit()

func state_load(data: Dictionary):
	var my_data = data[name]
	global_state = my_data['global_state']
	call_deferred('change_screen',my_data['screen'])


func state_save(data: Dictionary):
	data[name] = {
		'screen': screen,
		'global_state': global_state
	}
					
func change_screen(name):
	if get_tree().change_scene('res://scenes/%s.tscn' % name):
		printerr("Broken screen transition from %s to %s" % [screen, name])
	screen = name
	# Autosave between screens so web users have at least some persistence
	if OS.get_name() == 'HTML5':
		call_deferred('save_state')
