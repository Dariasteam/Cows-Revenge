extends StaticBody2D

export(Array) var text

onready var foreground = get_node("Foreground")
onready var background = get_node("Background")
onready var particles_a = get_node("Bars")
onready var particles_b = get_node("Dust")
onready var sound = get_node("StreamPlayer")

onready var text_label = get_node("Node2D/Text")
onready var text_anim = get_node("Node2D/Text/AnimationPlayer")

func _ready():	
	pass

func open_cage():
	sound.play()
	
	text_label.set_text( text[rand_range(0, text.size())])
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
