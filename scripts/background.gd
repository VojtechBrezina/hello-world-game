extends Node2D

var color := Color.black setget _set_color
signal transition_completed

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Global.screen_size), color)

func set_color(value):
	$Tween.interpolate_property(self, 'color', null, value, 1)
	$Tween.start()
	

func _set_color(value):
	color = value
	update()


func _on_Tween_tween_all_completed():
	emit_signal('transition_completed')

func state_load(data):
	var my_data = data[name]
	color = Color(my_data['color'])
	self.color = color

func state_save(data):
	data[name] = {
		'color': color.to_html(),
	}
