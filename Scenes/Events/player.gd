extends KinematicBody2D

signal looking_left
signal looking_right
signal update_milk
signal set_max_milk
signal update_life
signal set_max_life

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
onready var animation = get_node("sprite/animations")
onready var foots = get_node("foots")
onready var camera = get_node("sprite/Camera2D")

onready var hud_milk = get_tree().get_nodes_in_group("milk_hud")[0]
onready var hud_life = get_tree().get_nodes_in_group("life_hud")[0]


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

export(int) var life = 3

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
	emit_signal("update_milk", get_milk_level());

func get_milk_level():
	return milk_level

func decrease_milk(amount):
	milk_level = milk_level - amount
	emit_signal("update_milk", get_milk_level());

func on_opacity_low ():
	sprite.set_modulate(Color("fb12e7"))

func on_opacity_high ():
	sprite.set_modulate(Color("00ffff"))

func on_receive_damage (amount):
	if (can_receive_damage()):
		life = life - amount
		emit_signal ("update_life", life)
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

func _fixed_process(delta):
	if (jumping):
		jump_time -= altitude

	velocity.y += delta * GRAVITY
	
	# Salto
	if (can_jump and jump_key_pressed):		
		velocity.y = - JUMP_SPEED
		jumping = true
		jump_time = MAX_JUMP_TIME
		can_jump = false
	if (jumping and can_jump_more() and jump_key_pressed):		
		velocity.y = - JUMP_SPEED + (MAX_JUMP_TIME - jump_time) * 20
		jumping = true	
	
	# Movimiento horizontal	
	if (!right and !left):
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
		var normal = get_collision_normal()
		if (normal.y < -0.35):
			# Está en el suelo
			jumping = false
			can_jump = true
			motion.y = 0
			if (normal.y > -0.9):
				motion.x += motion.x * (-normal.y)
			motion = normal.slide(motion)
			velocity.y = 0
		else:			
			# Está chocándose contra techo o apred
			can_jump = false
			motion = normal.slide(motion)
			jump_time = 0
		move(motion)
	else:		
		can_jump = false

func _ready():
	
	connect("set_max_milk",hud_milk,"on_set_max_milk")
	connect("update_milk",hud_milk,"on_update_milk_bar")
	
	connect("update_life",hud_life,"on_update_life")
	connect("set_max_life",hud_life,"on_set_max_life")
	
	emit_signal("set_max_milk", get_max_milk())
	emit_signal("update_milk", get_milk_level())
	
	emit_signal("set_max_life", life)
	emit_signal("update_life", life)
	
	set_process_input(true)
	set_fixed_process(true)
	

func _input(ev):

	# Movimiento horizontal
	if (ev.is_action_pressed("ui_left")):
		left = true
		animation.play("walk")
		emit_signal("looking_left")
		velocity.x = -MAX_WALK_SPEED
		sprite.set_flip_h(true)		
	elif (ev.is_action_released("ui_left")):
		left = false
		
	if (ev.is_action_pressed("ui_right")):
		right = true
		animation.play("walk")
		velocity.x =  MAX_WALK_SPEED
		emit_signal("looking_right")
		sprite.set_flip_h(false)
	elif (ev.is_action_released("ui_right")):
		right = false
	
	if (!right and !left):
		animation.play("idle")
	# Arriba
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
		
	# Saltar
	if (ev.is_action_pressed("ui_jump")):
		jump_key_pressed = true
		
	elif (ev.is_action_released("ui_jump")):
		jump_time = 0
		jump_key_pressed = false