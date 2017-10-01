extends Area2D

export(int) var amount = 100

onready var sound = get_node("Sound")
onready var sprite = get_node("Sprite")
onready var timer = get_node("Timer")

func _ready():
	timer.connect("timeout",self,"queue_free")

func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		var pitch = body.add_cowbells(1)
		
		sound.set_default_pitch_scale(pitch)
		sound.play("cowbell_sound", 0)
		
		sprite.set_opacity(0)
		disconnect("body_enter",self,"_on_Area2D_body_enter")
		timer.start()
		
		
		
