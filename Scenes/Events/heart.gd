extends Area2D

export(int) var lifes = 1

onready var sound = get_node("Sound")
onready var sprite = get_node("Sprite")

func _ready():
	sound.connect("finished",self,"queue_free")

func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		if (body.can_add_life()):
			sprite.set_opacity(0)
			disconnect("body_enter",self,"_on_Area2D_body_enter")
			body.add_life()
			if global.sound:
				sound.play()
