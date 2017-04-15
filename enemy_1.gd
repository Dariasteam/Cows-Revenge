extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const GRAVITY = 3000.0

const FLYING_MOVEMENT_SPEED = 1
const JUMP_SPEED = 500
const SLIDE_LEVEL = 40
const MAX_JUMP_TIME = 60
const JUMP_CORRECTION_LEVEL = 1

const MAX_WALK_SPEED = 350
const WALK_SPEED_INCREMENT = 20
var walk_speed = 0

var can_jump = true
var jumping = false
var velocity = Vector2(100, 0)
var jump_time = 0
var jump_key_pressed = false

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	var motion = velocity * delta
	motion = move(motion)
	velocity.y += delta * GRAVITY
	if (is_colliding()):
		if (get_collider().is_in_group("player")):
			if (get_collision_normal().y < 1):
				print ("daño")
			else:
				queue_free()
		elif (get_collider().is_in_group("bullet")):
			print ("muerto por bala")
		
		if (abs(get_collision_normal().y) > 0.45):
			# Está en el suelo			
			var n = get_collision_normal()
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
		if (get_collision_normal().x < 0):
			velocity = Vector2(-100,0)
		elif (get_collision_normal().x > 0):
			velocity = Vector2(100,0)