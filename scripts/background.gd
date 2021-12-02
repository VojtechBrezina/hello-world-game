extends Node2D

var color := Color.black setget _set_color
var old_color := Color.black
var new_color := Color.black

var ready := true

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Global.screen_size), color)

func set_color(value):
	$Tween.interpolate_property(self, 'color', null, value, 1)
	$Tween.start()
	ready = false
	new_color = value
	get_tree().call_group('background', 'background_set', value)
	

func _set_color(value):
	color = value
	update()


func _on_Tween_tween_all_completed():
	ready = true
	old_color = color
	get_tree().call_group('background', 'background_ready')

func state_load(data):
	var my_data = data[name]
	old_color = Color(my_data['old_color'])
	new_color = Color(my_data['new_color'])
	ready = my_data['ready']
	if ready:
		self.color = new_color
	else:
		set_color(new_color)

func state_save(data):
	data[name] = {
		'old_color': old_color.to_html(),
		'new_color': new_color.to_html(),
		'ready': ready
	}
