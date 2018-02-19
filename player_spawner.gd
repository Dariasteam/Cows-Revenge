extends Node2D

const PLAYER = preload("res://Scenes/Events/player.tscn")
onready var anim = get_node("Sprite_cow/AnimationPlayer")
onready var instancer = get_node("Instancer")
var player

onready var cow_is_abducted = false

var mission_acomplished = false

func _ready():
	anim.play("appear")
	player = PLAYER.instance()
	instancer.call_deferred("add_child", player)
	yield(anim, "finished")
	player.enable_player()	
	
func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):
		set_process_input(true)
	
func _input(ev):
	if (ev.is_action_pressed("ui_up") and !cow_is_abducted):
		player.disable_player()
		anim.play("unvanish")
		cow_is_abducted = true
	if (ev.is_action_pressed("ui_down") and cow_is_abducted):
		anim.play("appear")
		yield(anim, "finished")
		player.enable_player()
		cow_is_abducted = false

func _on_Area2D_body_exit(body):
	if (body.is_in_group("player") and !cow_is_abducted):
		set_process_input(false)	