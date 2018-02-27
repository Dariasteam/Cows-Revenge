extends Node2D

onready var p1 = get_node("P1")
onready var p2 = get_node("P2")
onready var area = get_node("Area2D")

export(float) var time 

var emitting = true

func _ready():
	get_node("Timer").set_wait_time(time)

func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):
		body.on_receive_damage(1)

func toggle():
	if (emitting):
		p1.set_emitting(false)
		p2.set_emitting(false)
		area.disconnect("body_enter", self, "_on_Area2D_body_enter")
	else:
		p1.set_emitting(true)
		p2.set_emitting(true)
		area.connect("body_enter", self, "_on_Area2D_body_enter")
	emitting = !emitting

func _on_Timer_timeout():
	toggle()
