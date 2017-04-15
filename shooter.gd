extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const BULLET = preload("res://bullet.tscn")
var shooting = false

const SHOOT_CADENCE = 0.5

var shoot_dir = Vector2(500,-250)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):	
	if (Input.is_action_pressed("ui_shoot") and !shooting):
		
		var instanced_bullet = BULLET.instance()
		get_parent().get_parent().add_child(instanced_bullet)
		instanced_bullet.set_global_pos(get_global_pos())
		instanced_bullet.set_linear_velocity(shoot_dir)
		
		shooting = true
		
		var t = Timer.new()
		t.set_wait_time(SHOOT_CADENCE)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		shooting = false
	

func _on_KinematicBody2D_looking_left():
	shoot_dir = Vector2(-500,-250)
	set_pos(Vector2(-50, 0))

func _on_KinematicBody2D_looking_right():
	shoot_dir = Vector2(500,-250)
	set_pos(Vector2(50, 0))
