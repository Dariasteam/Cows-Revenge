extends StaticBody2D

export(String) var base_key_texts = "CHICKEN_ADVICE_"
export(int) var keys_size = 56
var texts = []

onready var foreground = get_node("Foreground")
onready var background = get_node("Background")
onready var particles_a = get_node("Bars")
onready var particles_b = get_node("Dust")
onready var sound = get_node("StreamPlayer")

onready var text_label = get_node("Node2D/Text")
onready var text_anim = get_node("Node2D/Text/AnimationPlayer")

func _ready():	
	for i in range(0, keys_size):
		texts.push_back(str(base_key_texts, i))

func open_cage():
	
	get_tree().get_nodes_in_group("player_spawner")[0].update_text()
	
	if global.sound:	
		sound.play()
	
	text_label.set_text( texts[rand_range(0, texts.size())])
	text_anim.play("Apear")
	
	get_node("Area2D").queue_free()
	get_node("CollisionShape2D").queue_free()
	particles_a.set_emitting(true)
	particles_b.set_emitting(true)
	foreground.queue_free()
	background.queue_free()
	
	remove_from_group("cages")
	

func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):
		body.open_cage(1)
		open_cage()
