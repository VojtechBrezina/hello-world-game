extends Node2D

var radius := .0 setget _set_radius

signal transition_completed

func _ready():
	position = Global.screen_size / 2

func _draw():
	if radius > 0:
		draw_circle(Vector2(0, 0), radius - 1, Color8(150, 150, 150))
		draw_arc(Vector2(0, 0), radius, 0, PI * 2.1, int(radius), Color8(150, 150, 150), 2, true)

func state_save(data):
	data[name] = {
		'radius': radius,
		'position': [position.x, position.y]
	}

func state_load(data):
	var my_data = data[name]
	radius = my_data['radius']
	position = Vector2(float(my_data['position'][0]), float(my_data['position'][1]))
	update()

func change_radius(value):
	$Tween.interpolate_property(self, 'radius', null, value, 1)

func _set_radius(value):
	radius = value
	update()


func _on_Tween_tween_all_completed():
	emit_signal('transition_completed')
