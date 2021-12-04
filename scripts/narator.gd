extends Node2D

var text := ''
var progress := 0 setget _set_progress 
var cursor := false

signal transition_completed

func _ready():
	pass

func _draw():
	var t = text.substr(0, progress)
	var ts = Global.font.get_string_size(t)
	draw_string(Global.font, \
		(Global.screen_size - ts) / 2 + Vector2(0, Global.font.size), \
		t, Color8(200, 200, 200))
	
	if text != '' and cursor:
		draw_rect(Rect2((Global.screen_size + ts) / 2 + Vector2(5, 0), Vector2(10, 2)), Color8(200, 200, 200))

func say(what):
	text = what
	$CursorTimer.stop()
	cursor = true
	$Tween.interpolate_property(self, 'progress', 0, len(what), 0.1 * len(what))
	$Tween.start()

func state_load(data):
	var my_data = data[name]
	text = my_data['text']
	progress = len(text)
	$CursorTimer.start()
	update()

func state_save(data):
	data[name] = {
		'text': text,
	}

func _set_progress(value):
	progress = value
	update()

func _on_Tween_tween_all_completed():
	if text != '':
		$CursorTimer.start()
	emit_signal('transition_completed')

func _on_CursorTimer_timeout():
	cursor = not cursor
	
	update()
