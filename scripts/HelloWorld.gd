extends Node2D

var clicks := 0
var step := 0

signal click

func _ready():
	Global.screen_ready()
	call_deferred('play_script')


func play_script():
	if not Global.state_loaded:
		yield(Global, 'state_loaded')

	if step == 0:
		Background.set_color(Color8(50, 50, 50))
		yield(Background, 'transition_completed')
		Narator.say("Hello world!")
		yield(Narator, 'transition_completed')
		step += 1
	
	if step == 1:
		for _i in range(10):
			yield(self, 'click')
		step += 1
	
	if step == 2:
		Narator.say("Is this really not enough?")
		yield(Narator, 'transition_completed')
		yield(self, 'click')
		step += 1

	if step == 3:
		Narator.say("I guess making a bouncing ball isn't that hard.")
		yield(Narator, 'transition_completed')
		yield(self, 'click')
		step += 1
	

func state_save(data):
	data[name] = {
		'step': step
	}

func state_load(data):
	var my_data = data[name]
	step = my_data['step']


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		emit_signal('click')
