extends Node2D

const BULLET = preload("res://Scenes/Events/milk_bullet.tscn")
export var SHOOT_CADENCE = 0.001

var shooting = false

signal change_milk_bottle

enum WEAPONS {
	regular,
	laser
}

var weapon = WEAPONS.regular
var shoot = false
var recharge = false

export(int) var bullet_cost = 1

onready var player = get_parent()
onready var instanced_ray = get_node("ray")

var shoot_dir = Vector2(500,-250)

func _ready():
	instanced_ray.set_player(player)
	connect("change_milk_bottle",get_tree().get_nodes_in_group("milk_hud")[0],"on_set_bottle_sprite")
	set_process_input(true)
	
func _input(ev):
	# SHOOT
	if (ev.is_action_pressed("ui_shoot")):
		set_process(true)
	elif (ev.is_action_released("ui_shoot")):
		instanced_ray.disable()
		shooting = false
		set_process(false)
		
	# CHANGE WEAPON
	if (ev.is_action_pressed("ui_change_weapon")):
		if (weapon == WEAPONS.regular):
			emit_signal("change_milk_bottle", 0)
			weapon = WEAPONS.laser
		else:
			emit_signal("change_milk_bottle", 1)
			instanced_ray.disable()
			weapon = WEAPONS.regular
	
		
func check_can_shoot():
	return global.milk_level  > 0

func shoot_regular():
	
	var instanced_bullet = BULLET.instance()
	get_parent().get_parent().add_child(instanced_bullet)
	instanced_bullet.set_global_pos(get_global_pos())
	instanced_bullet.set_linear_velocity(shoot_dir + Vector2(rand_range(-100, 100) + get_parent().velocity.x, rand_range(-100, 100)))

	recharge = true
	var t = Timer.new()
	t.set_wait_time(SHOOT_CADENCE)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	recharge = false
	player.decrease_milk(bullet_cost)

func shoot_laser():
	player.decrease_milk(0.3)

func _process(delta):
	if (check_can_shoot()):
		if (weapon == WEAPONS.regular and !recharge):
			shoot_regular()
		elif (weapon == WEAPONS.laser):
			shoot_laser()
			if (!shooting):
				shooting = true
				instanced_ray.enable()
	else:
		shooting = false
		instanced_ray.disable()
		set_process(false)
	
func _on_KinematicBody2D_looking_left():
	shoot_dir = Vector2(-500,-250)
	set_pos(Vector2(-21, 0))
	instanced_ray.look_left()

func _on_KinematicBody2D_looking_right():
	shoot_dir = Vector2(500,-250)
	set_pos(Vector2(25, 0))
	instanced_ray.look_right()
