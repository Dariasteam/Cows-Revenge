extends KinematicBody2D

signal looking_left
signal looking_right
signal update_milk
signal set_max_milk
signal update_life
signal set_max_life

const GRAVITY = 4000.0

const FLYING_MOVEMENT_SPEED = 1
const SLIDE_LEVEL = 80
const WALK_SPEED_INCREMENT = 20

var walk_speed = 0
var floor_velocity = Vector2()

onready var shooter = get_node("shooter")
onready var sprite = get_node("sprite")
onready var animation = get_node("sprite/animations")
onready var foots = get_node("foots")
onready var camera = get_node("sprite/Camera2D")
onready var sound = get_node("sound")

onready var hud_milk = get_tree().get_nodes_in_group("milk_hud")[0]
onready var hud_life = get_tree().get_nodes_in_group("life_hud")[0]
onready var hud_cowbell = get_tree().get_nodes_in_group("cowbell_hud")[0]

onready var cowbell_collector = get_node("cowbell_collector")

var can_jump = true
var on_ground = true
var jumping = false
var velocity = Vector2()
var final_velocity = Vector2()
var jump_time = 0
var jump_key_pressed = false
var jump_key_released = true
var colliding_in_jump = false

var right = false
var left = false

var receive_damage = true

export(int) var MAX_JUMP_TIME = 20
export(int) var MAX_WALK_SPEED = 450
export(int) var invulneravility_time = 16

export var JUMP_SPEED = 400
export var altitude = 0.5
export(int) var cages_open = 0

func _integrate_forces(s):
	print ("a")
	var lv = s.get_linear_velocity()
	var step = s.get_step()

func open_cage(var number):
	cages_open += number

func add_cowbells(var number):
	global.cowbells += number
	hud_cowbell.set_counter (global.cowbells, cowbell_collector.play_sound())

func add_bonus (var quantity):
	global.cowbells += quantity
	hud_cowbell.bonus(quantity)

func is_falling ():
	return velocity.y > 0

func add_milk(amount):
	if (global.milk_level + amount > global.max_milk):
		global.milk_level = global.max_milk
	else:
		global.milk_level += amount
	emit_signal("update_milk", global.milk_level);

func can_add_life():
	if (global.life < global.max_life):
		return true
	else:
		return false

func add_life():
	global.life += 1
	emit_signal ("update_life", global.life)

func decrease_milk(amount):
	global.milk_level = global.milk_level - amount
	emit_signal("update_milk", global.milk_level );

func on_opacity_low ():
	sprite.set_modulate(Color("fb12e7"))

func on_opacity_high ():
	sprite.set_modulate(Color("00ffff"))

func on_receive_damage (amount):
	if (can_receive_damage()):
		global.life = global.life - amount
		emit_signal ("update_life", global.life)
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

func play_sound():	
	if global.sound:
		sound.play()

func _fixed_process(delta):
	if (jumping):
		jump_time -= altitude

	velocity.y += delta * GRAVITY

	# Salto
	if (can_jump and jump_key_pressed):
		play_sound()
		velocity.y = - JUMP_SPEED
		velocity += floor_velocity
		jumping = true
		jump_time = MAX_JUMP_TIME
		can_jump = false

	if (jumping and can_jump_more() and jump_key_pressed):
		velocity.y = - JUMP_SPEED + (MAX_JUMP_TIME - jump_time) * 20

	# Movimiento horizontal
	if (!right and !left):
		if (velocity.x > SLIDE_LEVEL):
			velocity.x -= SLIDE_LEVEL
		elif (velocity.x < -SLIDE_LEVEL):
			velocity.x += SLIDE_LEVEL
		else:
			velocity.x = 0

	var motion = velocity * delta

	if (jumping and test_move(motion)):
		if (motion.x < 0):
			motion.x = 0.15
		else:
			motion.x = -0.15

	if (!colliding_in_jump):
		motion = move(motion)
	else:
		motion = move(Vector2(0, motion.y))
		colliding_in_jump = false

	# Control de colisiones
	if (is_colliding()):
		var normal = get_collision_normal()

		if (normal.y < -0.35):

			floor_velocity =  get_collider_velocity()
			if (floor_velocity != Vector2()):
				move(Vector2(floor_velocity.x / 60, floor_velocity.y / 60))
				motion.y = 0
				velocity.y = 0

			# Está en el suelo
			if (!jumping and jump_key_released):
				on_ground = true
				can_jump = true
			jumping = false
			motion.y = 0
			if (normal.y > -0.9):
				motion.x += motion.x * (-normal.y)
			motion = normal.slide(motion)
			velocity.y = 0

		else:
			# Está chocándose contra techo o pared
			can_jump = false
			colliding_in_jump = true
			motion = normal.slide(motion)
			jump_time = 0
			# Si está chocando contra el techo hacerlo caer
			if (normal.y > 0.2):
				velocity.y = 0


		move(motion)
	else:
		can_jump = false


func enable_player():
	set_process_input(true)
	set_fixed_process(true)
	sprite.set_opacity(1)
	reset_inputs()

func disable_player():
	set_process_input(false)
	set_fixed_process(false)
	sprite.set_opacity(0)

func _ready():
	#global.reset_player()
	sprite.set_opacity(0)
	connect("set_max_milk",hud_milk,"on_set_max_milk")
	connect("update_milk",hud_milk,"on_update_milk_bar")

	connect("update_life",hud_life,"on_update_life")
	connect("set_max_life",hud_life,"on_set_max_life")

	#emit_signal("update_milk", global.milk_level)

	emit_signal("update_life", global.life)

func set_movement_left ():
	animation.play("walk")
	emit_signal("looking_left")
	velocity.x = -MAX_WALK_SPEED
	sprite.set_flip_h(true)

func set_movement_right():
	animation.play("walk")
	velocity.x =  MAX_WALK_SPEED
	emit_signal("looking_right")
	sprite.set_flip_h(false)

func reset_inputs():
	left = false
	right = false
	jump_key_pressed = false
	jump_key_released = true

func _input(ev):
	# Movimiento horizontal
	if (ev.is_action_pressed("ui_left")):
		left = true
		if (!right):
			set_movement_left()
	elif (ev.is_action_released("ui_left")):
		left = false
		if (right):
			set_movement_right()

	if (ev.is_action_pressed("ui_right")):
		right = true
		if (!left):
			set_movement_right()
	elif (ev.is_action_released("ui_right")):
		right = false
		if (left):
			set_movement_left()

	if (!right and !left):
		animation.play("idle")
	# Arriba
	if (ev.is_action_pressed("ui_up")):
		pass
	elif (ev.is_action_released("ui_up")):
		pass

	# Agacharse
	if (ev.is_action_pressed("ui_down")):
		get_node("Collision_Agachado").set_trigger(false)
		get_node("Collision_Normal").set_trigger(true)
		set_collision_mask_bit(11, 0)
	elif (ev.is_action_released("ui_down")):
		get_node("Collision_Normal").set_trigger(false)
		get_node("Collision_Agachado").set_trigger(true)
		set_collision_mask_bit(11, 1)

	# Saltar
	if (ev.is_action_pressed("ui_jump") and jump_key_released):
		jump_key_pressed = true

	elif (ev.is_action_released("ui_jump")):
		jump_key_released = true
		jump_time = 0
		jump_key_pressed = false
