extends KinematicBody2D

signal looking_left
signal looking_right

signal update_milk

const GRAVITY = 3500.0

const FLYING_MOVEMENT_SPEED = 1
export var JUMP_SPEED = 400
const SLIDE_LEVEL = 40
export(int) var MAX_JUMP_TIME = 20

export var altitude = 0.5

export(int) var MAX_WALK_SPEED = 450
const WALK_SPEED_INCREMENT = 20
var walk_speed = 0

onready var shooter = get_node("shooter")
onready var sprite = get_node("sprite")
onready var foots = get_node("foots")

var can_jump = true
var jumping = false
var velocity = Vector2()
var final_velocity = Vector2()
var jump_time = 0
var jump_key_pressed = false

var right = false
var left = false

var receive_damage = true

export(int) var max_milk = 500
export(int) var milk_level = 0

export(int) var invulneravility_time = 16

func is_falling ():
	return velocity.y > 0

func get_max_milk():
	return max_milk

func add_milk(amount):
	if (milk_level + amount > max_milk):
		milk_level = max_milk
	else:
		milk_level += amount
	emit_signal("update_milk", get_max_milk(), get_milk_level());

func get_milk_level():
	return milk_level

func decrease_milk(amount):
	milk_level = milk_level - amount
	emit_signal("update_milk", get_max_milk(), get_milk_level());

func on_opacity_low ():
	sprite.set_modulate(Color("fb12e7"))

func on_opacity_high ():
	sprite.set_modulate(Color("00ffff"))

func on_receive_damage ():
	if (can_receive_damage()):
		show_damage()

func can_receive_damage ():
	return receive_damage

func change_collision ():
	sprite.set_modulate(Color("ffffff"))
	receive_damage = !receive_damage
	set_layer_mask_bit(0, !get_layer_mask_bit(0))
	set_layer_mask_bit(5, !get_layer_mask_bit(5))

func show_damage ():
	change_collision()
	var t1 = Timer.new()
	var t2 = Timer.new()
	t1.set_wait_time(0.07)
	t2.set_wait_time(0.07)
	t1.set_one_shot(true)
	t2.set_one_shot(true)
	t1.connect("timeout",self,"on_opacity_low")
	t2.connect("timeout",self,"on_opacity_high")
	add_child(t1)
	add_child(t2)
	for i in range(invulneravility_time):
		t1.start()
		yield(t1, "timeout")
		t2.start()
		yield(t2, "timeout")
	change_collision()

func can_jump_more ():
	return jump_time > 0

func horizontal_movement_amount ():
	if (walk_speed < MAX_WALK_SPEED):
		walk_speed += WALK_SPEED_INCREMENT
	return walk_speed

func _fixed_process(delta):
	if (jumping):
		jump_time -= altitude

	velocity.y += delta * GRAVITY
	
	# Salto
	if (jumping and can_jump_more() and jump_key_pressed):		
		velocity.y = - JUMP_SPEED + (MAX_JUMP_TIME - jump_time) * 20
		sprite.stop()
		jumping = true	
	

	# Movimiento horizontal	
	if (!right and !left):
		sprite.set_animatiºon("Idle")		
		if (velocity.x > SLIDE_LEVEL): 
			velocity.x -= SLIDE_LEVEL
		elif (velocity.x < -SLIDE_LEVEL):
			velocity.x += SLIDE_LEVEL
		else:		
			velocity.x = 0
			walk_speed = 0
	
	var motion = velocity * delta

	if (jumping and test_move(motion)):
		if (motion.x < 0):
			motion.x = 0.15
		else:
			motion.x = -0.15

	motion = move(motion)

	# Control de colisiones	
	
	if (is_colliding()):
		sprite.play("")
		var normal = get_collision_normal()
		jumping = false
		if (normal.y > 0.5 and jumping):
			# Está chocandose contra el techo			
			can_jump = false
			jump_time = 0
		else:			
			# Está en el suelo
			
			if (normal.y < -0.25):
				can_jump = true
				motion.y = 0
				motion = normal.slide(motion)
				final_velocity = normal.slide(final_velocity)
				velocity.y = 0
			else:				
				motion = normal.slide(motion)
				final_velocity = normal.slide(final_velocity)
			move(motion)
			
	else:		
		can_jump = false

func key_left_pressed():
	pass

func _ready():
	connect("update_milk",get_tree().get_nodes_in_group("control")[0],"on_update_milk_bar")
	emit_signal("update_milk", get_max_milk(), get_milk_level())
	set_fixed_process(true)	
	set_process_input(true)
	

func _input(ev):

	if (ev.is_action_pressed("ui_left")):
		left = true
		sprite.set_animation("walk")
		emit_signal("looking_left")
		velocity.x = -450
		sprite.set_flip_h(true)
	elif (ev.is_action_released("ui_left")):
		left = false
		
	if (ev.is_action_pressed("ui_right")):
		right = true
		sprite.set_animation("walk")
		velocity.x =  450
		emit_signal("looking_right")
		sprite.set_flip_h(false)
	elif (ev.is_action_released("ui_right")):
		right = false
	


	
	if (ev.is_action_pressed("ui_up")):
		print("ui_up on")
	elif (ev.is_action_released("ui_up")):
		print("ui_up off")
	
	# Agacharse
	if (ev.is_action_pressed("ui_down")):
		get_node("Collision_Normal").set_trigger(true)
		get_node("Collision_Agachado").set_trigger(false)
	elif (ev.is_action_released("ui_down")):
		get_node("Collision_Normal").set_trigger(false)
		get_node("Collision_Agachado").set_trigger(true)
		
	if (ev.is_action_pressed("ui_jump")):
		jump_key_pressed = true
		velocity.y = - JUMP_SPEED
		jumping = true
		jump_time = MAX_JUMP_TIME
		can_jump = false
	elif (ev.is_action_released("ui_jump")):
		jump_key_pressed = false