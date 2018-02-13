extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var timer = get_node("next_cowbell_time")
const SAMPLE_LIBRARY = preload("res://Scenes/Events/cowbell_sample_library.tres")

export(float) var pitch_increment = 0.05
export(float) var base_pitch = 1.5

var pitch = base_pitch

func timer_timeout():
	pitch = base_pitch

func play_sound():
	pitch += pitch_increment
	
	var sample_player = SamplePlayer.new()
	sample_player.set_sample_library(SAMPLE_LIBRARY)
	sample_player.set_default_pitch_scale(pitch)	
	sample_player.set_default_volume(40)
	
	var aux_timer = Timer.new()
	aux_timer.set_one_shot(true)
	aux_timer.set_wait_time(0.5)
	
	aux_timer.connect("timeout",sample_player,"queue_free")
	
	add_child(sample_player)
	sample_player.add_child(aux_timer)	
	
	sample_player.play("cowbell_sound")
	aux_timer.start()
	
	timer.start()
	return pitch - base_pitch

func _ready():	
	timer.connect("timeout",self,"timer_timeout")
