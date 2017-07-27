extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const BULLET = preload("res://bullet.tscn")
export var SHOOT_CADENCE = 0.5

enum WEAPONS {
	regular,
	laser
}

var weapon = WEAPONS.laser
var shooting = false

onready var player = get_parent()
onready var instanced_ray = get_node("ray")

var shoot_dir = Vector2(500,-250)

func _ready():
	set_fixed_process(true)


func shoot_regular ():
	var instanced_bullet = BULLET.instance()
	get_parent().get_parent().add_child(instanced_bullet)
	instanced_bullet.set_global_pos(get_global_pos())
	instanced_bullet.set_linear_velocity(shoot_dir + Vector2(rand_range(-100, 100), rand_range(-100, 100)))
	
	shooting = true
	
	var t = Timer.new()
	t.set_wait_time(SHOOT_CADENCE)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	shooting = false
	player.decrease_milk()

func shoot_laser():
	player.decrease_milk()	

func _fixed_process(delta):		
	if (Input.is_action_pressed("ui_shoot") and !shooting and player.get_milk_level() > 0):
		if (weapon == WEAPONS.regular):
			shoot_regular()
		elif (weapon == WEAPONS.laser):
			instanced_ray.enable()
			shoot_laser()
	else:
		instanced_ray.disable()

func _on_KinematicBody2D_looking_left():
	shoot_dir = Vector2(-500,-250)
	set_pos(Vector2(-30, 0))
	instanced_ray.look_left()

func _on_KinematicBody2D_looking_right():
	shoot_dir = Vector2(500,-250)
	set_pos(Vector2(30, 0))
	instanced_ray.look_right()
