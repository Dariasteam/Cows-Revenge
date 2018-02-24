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
var rest = total_cages


func _ready():	
	texts.set_text(str(init_text, "\n", append_text, total_cages, "."))
	sound.play()
	anim.play("appear")
	player = PLAYER.instance()
	instancer.call_deferred("add_child", player)	
	yield(anim, "finished")	
	player.enable_player()	

func abduct():
	sound.play()
	player.disable_player()
	anim.play("unvanish")	
	global.save_cowbells()
	get_tree().get_nodes_in_group("ufo_store")[0].show()

func liftoff():	
	get_tree().get_nodes_in_group("level_selector")[0].next_level()
		
func deploy():	
	sound.play()
	anim.play("appear")
	yield(anim, "finished")
	player.enable_player()
	
func can_liftoff():
	return rest == 0
		
func update_text():
	rest = total_cages - player.cages_open
	texts.set_text(str(init_text, "\n", append_text, rest, "."))

func _input(ev):
	if (ev.is_action_pressed("ui_up")):
		abduct()
	
func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):
		update_text()
		set_process_input(true)
	
func _on_Area2D_body_exit(body):
	if (body.is_in_group("player")):
		set_process_input(false)	