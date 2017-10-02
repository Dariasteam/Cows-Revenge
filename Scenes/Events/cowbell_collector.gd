extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var timer = get_node("next_cowbell_time")

export(float) var pitch_increment = 0.05
export(float) var base_pitch = 1.5

var pitch = base_pitch

func timer_timeout():
	pitch = base_pitch

func play_sound():
	pitch += pitch_increment
	timer.start()
	return pitch

func _ready():	
	timer.connect("timeout",self,"timer_timeout")
