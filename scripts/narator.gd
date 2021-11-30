extends Node2D

var text := ''
var progress := 0 setget _set_progress 
var cursor := false

var ready := true

func _ready():
	pass

func _draw():
	var t = text.substr(0, progress)
	var ts = Global.font.get_string_size(t)
	draw_string(Global.font, \
		(Global.screen_size - ts) / 2 + Vector2(0, Global.font.size), \
		t, Color8(200, 200, 200))
	
	if cursor:
		draw_rect(Rect2((Global.screen_size + ts) / 2 + Vector2(5, 0), Vector2(10, 2)), Color8(200, 200, 200))

func say(what):
	text = what
	$CursorTimer.stop()
	cursor = true
	ready = false
	$Tween.interpolate_property(self, 'progress', 0, len(what), 0.1 * len(what))
	$Tween.start()
	get_tree().call_group('narator', 'narator_say', what)

func _set_progress(value):
	progress = value
	update()

func _on_Tween_tween_all_completed():
	$CursorTimer.start()
	ready = true
	get_tree().call_group('narator', 'narator_ready')


func _on_CursorTimer_timeout():
	cursor = not cursor
	update()
