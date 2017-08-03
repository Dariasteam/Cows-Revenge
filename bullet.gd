extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var LIFE_TIME = 3

onready var particles = get_node("Trail")
onready var splash = get_node("Splash")

var t = Timer.new()

func destroy():
	set_process(false)
	set_linear_velocity(Vector2(0,0))
	set_angular_velocity(0)

	splash.set_emitting(true)
	particles.set_emitting(false)

	t.set_wait_time(max (particles.get_lifetime(), (splash.get_lifetime() + splash.get_emit_timeout())))
	t.start()
	yield(t, "timeout")

	queue_free()

func _process(delta):
	if (get_colliding_bodies().size() > 0):
		set_process(false)
		destroy()

func _ready():
	t.set_wait_time(LIFE_TIME)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	set_process(true)

func _on_RigidBody2D_body_enter( body ):
	if (body.is_in_group("enemy")):
		body.decrease_life(1)
		destroy()
	
