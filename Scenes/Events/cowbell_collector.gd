extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var timer = get_node("next_cowbell_time")

export(float) var pitch_increment = 0.05

var pitch = 1

func timer_timeout():
	pitch = 1

func play_sound():
	pitch += pitch_increment
	print ("sound ", pitch)
	
	timer.start()
	return pitch

func _ready():	
	timer.connect("timeout",self,"timer_timeout")
