extends Node2D

onready var color: Color = Color.black setget _set_color

var ready := true

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Global.screen_size), color)

func set_color(value):
	$Tween.interpolate_property(self, 'color', null, value, 1)
	$Tween.start()
	ready = false
	get_tree().call_group('background', 'background_set', value)
	

func _set_color(value):
	color = value
	update()


func _on_Tween_tween_all_completed():
	ready = true
	get_tree().call_group('background', 'background_ready')
