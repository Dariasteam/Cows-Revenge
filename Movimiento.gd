extends KinematicBody2D

signal looking_left
signal looking_right

const GRAVITY = 3000.0

const FLYING_MOVEMENT_SPEED = 1
export var JUMP_SPEED = 500
const SLIDE_LEVEL = 40
const MAX_JUMP_TIME = 60

export var altitude = 0.5

const MAX_WALK_SPEED = 350
const WALK_SPEED_INCREMENT = 20
var walk_speed = 0

onready var shooter = get_node("shooter")
onready var sprite = get_node("sprite")

var can_jump = true
var jumping = false
var velocity = Vector2()
var jump_time = 0
var jump_key_pressed = false

var last_collition_pos = Vector2(100000,10000)

func can_jump_more ():	
	return jump_time > 0
	
func horizontal_movement_amount ():
	if (is_colliding() and get_collision_normal().x != 0):		
		return 0
	else:
		if (walk_speed < MAX_WALK_SPEED):
			walk_speed += WALK_SPEED_INCREMENT
		return walk_speed

func _fixed_process(delta):
	
	
	if (jumping):
		jump_time -= altitude
	velocity.y += delta * GRAVITY
	
	# Salto	
	if (Input.is_action_pressed("ui_jump")):
		if (jumping and can_jump_more() and jump_key_pressed):
			velocity.y = - JUMP_SPEED + (MAX_JUMP_TIME - jump_time) * 20
			jumping = true
		elif(can_jump and !jump_key_pressed):
			velocity.y = - JUMP_SPEED
			jump_time = MAX_JUMP_TIME
			can_jump = false
			jumping = true
			jump_key_pressed = true
	else:
		jump_key_pressed = false
   
	# Movimiento horizontal
	if (Input.is_action_pressed("ui_left")):
		emit_signal("looking_left");
		velocity.x = - horizontal_movement_amount()
		sprite.set_flip_h(true)
	elif (Input.is_action_pressed("ui_right")):
		velocity.x =  horizontal_movement_amount()
		emit_signal("looking_right");
		sprite.set_flip_h(false)
	else:
		if (velocity.x > SLIDE_LEVEL):
			velocity.x -= SLIDE_LEVEL
		elif (velocity.x < -SLIDE_LEVEL):
			velocity.x += SLIDE_LEVEL
		else:
			velocity.x = 0
			walk_speed = 0
			
	# Agacharse
	if (Input.is_action_pressed("ui_down")):
		get_node("Collision_Normal").set_trigger(true)
		get_node("Collision_Agachado").set_trigger(false)
	else:		
		get_node("Collision_Normal").set_trigger(false)
		get_node("Collision_Agachado").set_trigger(true)
	
	var motion = velocity * delta
	motion = move(motion)

	# Control de colisiones
	if (is_colliding()):
		var normal = get_collision_normal()
		if (normal.x != 0):
			last_collition_pos = normal
		
		if (normal.y < 0):
			# Está en el suelo
			can_jump = true
			jumping = false
			motion = normal.slide(motion)
			velocity = normal.slide(velocity)
			move(motion)
		elif (normal.y > 0):
			# Está chocandose contra el techo
			jumping = false
			can_jump = false 
			jump_time = 0
	else:
		can_jump = false
	

func _ready():
	set_fixed_process(true)