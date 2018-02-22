extends StaticBody2D

export(String) var text

onready var foreground = get_node("Foreground")
onready var background = get_node("Background")
onready var particles_a = get_node("Bars")
onready var particles_b = get_node("Dust")
onready var sound = get_node("StreamPlayer")

onready var text_label = get_node("Text")
onready var text_anim = get_node("Text/AnimationPlayer")

func _ready():	
	pass

func open_cage():
	sound.play()
	
	text_label.set_text(text)
	text_anim.play("Apear")
	
	get_node("Area2D").queue_free()
	get_node("CollisionShape2D").queue_free()
	particles_a.set_emitting(true)
	particles_b.set_emitting(true)
	foreground.queue_free()
	background.queue_free()
	

func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):
		body.open_cage(1)
		open_cage()
