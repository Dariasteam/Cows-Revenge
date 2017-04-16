extends KinematicBody2D

signal damage

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const GRAVITY = 3000.0

var vertical
export var velocity = 250
var v = Vector2(-velocity, 0)

onready var sprite = get_node("Sprite")

export(bool) var dir_left = true;

export var damage = 1

func reverse_direction():
	sprite.set_flip_h(v.x < 0)	
	v = Vector2(-v.x,0)

func _ready():
	connect("damage", get_tree().get_root().get_node("Node2D"), "on_damage")
	if (!dir_left):
		reverse_direction()
	set_fixed_process(true)
	
func _fixed_process(delta):	
	var motion = v * delta
	motion = move(motion)	
	v.y += delta * GRAVITY
	
	if (is_colliding()):
		var normal = get_collision_normal();
		var collider = get_collider()
		
		if (collider.is_in_group("player")):
			if (normal.y < 0.7):
				emit_signal("damage", damage)
			else:
				Input.action_press("ui_jump")
				var t = Timer.new()
				get_node("Sprite").set_opacity(0)
				set_shape_as_trigger(0, true)
				t.set_wait_time(0.2)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				queue_free()
				Input.action_release("ui_jump")
		elif (collider.is_in_group("bullet")):
			collider.queue_free()
			queue_free()
			
		else:
			if (normal.y < 0):
				if (normal.y > -1):
					v.y = -velocity
				var aux = v.x
				motion = normal.slide(motion)
				v = normal.slide(v)
				move(motion)
				v.x = aux			
			if (normal.x < -0.75 or normal.x > 0.75):
				reverse_direction()