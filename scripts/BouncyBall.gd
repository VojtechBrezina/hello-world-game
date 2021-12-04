extends Node2D

var step := 0

func _ready():
	Global.screen_ready()
	call_deferred('play_script')


func play_script():
	if not Global.state_loaded:
		yield(Global, 'state_loaded')

	if step == 0:
		Narator.say('')
		yield(Narator, 'transition_completed')
		Background.set_color(Color8(10, 10, 10))
		yield(Background, 'transition_completed')