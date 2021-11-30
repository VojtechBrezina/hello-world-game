extends Node2D

onready var screen_size := get_viewport().size

var font: DynamicFont

func _ready():
	font = DynamicFont.new()
	font.font_data = load('res://Connection.otf')
	font.size = 20
	font.use_filter = false

	
