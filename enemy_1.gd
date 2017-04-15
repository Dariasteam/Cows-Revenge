extends KinematicBody2D

signal damage

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const GRAVITY = 3000.0

const JUMP_SPEED = 500
const SLIDE_LEVEL = 40

const MAX_WALK_SPEED = 350
const WALK_SPEED_INCREMENT = 20
var walk_speed = 0
var velocity = Vector2(100, 0)

export var damage = 1

func _ready():
	connect("damage", get_tree().get_root().get_node("Node2D"), "on_damage")
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	var motion = velocity * delta
	motion = move(motion)
	velocity.y += delta * GRAVITY
	if (is_colliding()):
		var normal = get_collision_normal();
		if (get_collider().is_in_group("player")):
			if (get_collision_normal().y < 1):
				emit_signal("damage", damage)
				queue_free()
			else:
				queue_free()
		elif (get_collider().is_in_group("bullet")):
			queue_free()
		else:
			if (normal.y == -1):
				# Está en el suelo			
				var n = get_collision_normal()
				motion = n.slide(motion)
				velocity = n.slide(velocity)
				move(motion)
			if (normal.x < 0):
				velocity = Vector2(-100,0)
			elif (normal.x > 0):
				velocity = Vector2(100,0)