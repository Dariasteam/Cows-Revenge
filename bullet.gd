extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var LIFE_TIME = 3

onready var particles = get_node("Trail")
onready var splash = get_node("Splash")

var t = Timer.new()

func destroy():
	set_linear_velocity(Vector2(0,0))
	set_angular_velocity(0)
	
	splash.set_emitting(true)	
	particles.set_emitting(false)
	
	t.set_wait_time(max (particles.get_lifetime(), (splash.get_lifetime() + splash.get_emit_timeout())))
	t.start()
	yield(t, "timeout")
	
	queue_free()
	

func _fixed_process(delta):
	if (get_colliding_bodies().size() > 0):
		set_fixed_process(false)
		destroy()
	
func _ready():
	
	t.set_wait_time(LIFE_TIME)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")	
	set_fixed_process(true)

