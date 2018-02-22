extends Node2D

const PLAYER = preload("res://Scenes/Events/player.tscn")
onready var anim = get_node("Sprite_cow/AnimationPlayer")
onready var sound = get_node("Sound")
onready var instancer = get_node("Instancer")
onready var texts = get_node("UFO_texts")
onready var total_cages = get_tree().get_nodes_in_group("cages").size()

export(String, MULTILINE) var init_text = "Vuelve cuando hayas\n salvado a todas las gallinas."
export(String, MULTILINE) var append_text

var player

onready var cow_is_abducted = false

var mission_acomplished = false

func _ready():
	texts.set_text(str(init_text, "\n", append_text, total_cages, "."))
	sound.play()
	anim.play("appear")
	player = PLAYER.instance()
	instancer.call_deferred("add_child", player)	
	yield(anim, "finished")	
	player.enable_player()	
	
func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):
		set_process_input(true)

func abduct():
	sound.play()
	player.disable_player()
	anim.play("unvanish")
	cow_is_abducted = true		
	
	var rest = total_cages - player.cages_open
	if (rest > 0):
		texts.set_text(str(init_text, "\n", append_text, rest, "."))
	else:
		get_tree().get_nodes_in_group("level_selector")[0].next_level()
		
func deploy():	
	sound.play()
	anim.play("appear")
	yield(anim, "finished")
	player.enable_player()
	cow_is_abducted = false
	
func _input(ev):
	if (ev.is_action_pressed("ui_up") and !cow_is_abducted):
		abduct()
	if (ev.is_action_pressed("ui_down") and cow_is_abducted):		
		deploy()
func _on_Area2D_body_exit(body):
	if (body.is_in_group("player") and !cow_is_abducted):
		set_process_input(false)	