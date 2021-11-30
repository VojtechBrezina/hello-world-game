extends Node2D

var clicks := 0
var step := 0

func _ready():
	Background.set_color(Color8(50, 50, 50))

func background_ready():
	Narator.say("Hello World!")

func narator_ready():
	match step:
		1:
			yield(get_tree().create_timer(1), 'timeout')
			step += 1
			Narator.say("A simple hello world isn't enough?")
		3:
			yield(get_tree().create_timer(1), 'timeout')
			step += 1
			Narator.say("I can make you a bouncy ball.")


func _input(event):
	if not Narator.ready:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		clicks += 1
		match step:
			0:
				if clicks >= 10:
					step += 1
					Narator.say("Waht's wrong?")
					clicks = 0
			2:
				step += 1
				Narator.say("Alright. If you insist...")
