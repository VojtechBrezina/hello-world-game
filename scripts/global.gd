extends Node

onready var screen_size := get_viewport().size

var font: DynamicFont

var screen = 'StartScreen'

var global_state := {}

var state_loaded = false

signal state_loaded
signal state_saved
signal screen_ready

func _ready():
	font = DynamicFont.new()
	font.font_data = load('res://Connection.otf')
	font.size = 20
	font.use_filter = false

	call_deferred('load_state')

func _notification(what: int):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		call_deferred('save_state')
		yield(self, 'state_saved')
		get_tree().quit()

func load_state():
	var file := File.new()
	var error := file.open('user://state.json', File.READ)
	if not error:
		var data: Dictionary = JSON.parse(file.get_as_text()).result
		change_screen(data[name]['screen'])
		yield(self, 'screen_ready')
		get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, 'state', 'state_load', data)
		file.close()
	elif error == ERR_FILE_NOT_FOUND:
		change_screen('HelloWorld')
	else:
		printerr("Error loading state.")
		get_tree().quit()

	state_loaded = true
	emit_signal('state_loaded')
		
func save_state():
	var file := File.new()
	var data = {}
	
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, 'state', 'state_save', data)
	
	if !file.open('user://state.json', File.WRITE):
		get_tree().quit()
		file.store_string(JSON.print(data, "    " if OS.is_debug_build() else ""))
		file.close()
	else:
		printerr("Error saving state.")
	
	emit_signal('state_saved')

func state_load(data: Dictionary):
	var my_data = data[name]
	global_state = my_data['global_state']

func state_save(data: Dictionary):
	data[name] = {
		'screen': screen,
		'global_state': global_state
	}
					
func change_screen(name):
	if get_tree().change_scene('res://screens/%s.tscn' % name):
		printerr("Broken screen transition from %s to %s" % [screen, name])
		# Autosave between screens so web users have at least some persistence

	if OS.get_name() == 'HTML5' and screen != 'StartScreen':
		yield(self, 'screen_ready')
		call_deferred('save_state')

	screen = name
	

func screen_ready():
	emit_signal('screen_ready')