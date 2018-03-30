extends Node2D

export (int) var damage = 1
export (int) var velocity = 13
export (int) var animation_speed = 3

var vel_vec = Vector2(-velocity,0);

func _ready():	
	set_process(true)

func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):
		body.on_receive_damage(damage)
	queue_free()

func set_right (right):
	if (right):
		get_node("Sprite/AnimationPlayer").set_speed(-animation_speed)
		vel_vec = Vector2(velocity,0);
	else:
		get_node("Sprite/AnimationPlayer").set_speed(animation_speed)
		vel_vec = Vector2(-velocity,0);

func _process(delta):	
	set_pos(get_pos() + vel_vec)	