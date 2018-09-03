extends RigidBody2D

export var LIFE_TIME = 3

onready var trail = get_node("Trail")
onready var splash = get_node("Splash")
onready var sound = get_node("Sound")

var t = Timer.new()
var end = false

func destroy():
	call_deferred("set_contact_monitor",false)
	set_linear_velocity(Vector2(0,0))
	set_angular_velocity(0)

	splash.set_emitting(true)
	trail.set_emitting(false)

	t.set_wait_time(max (trail.get_lifetime(), (splash.get_lifetime() + splash.get_emit_timeout())))	
	t.start()
	yield(t, "timeout")
	queue_free()

func _ready():
	if global.sound:
		sound.play("bullet_sound",0)
	t.set_wait_time(LIFE_TIME)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	end = true

func _on_RigidBody2D_body_enter( body ):	
	if (body.is_in_group("enemy")):
		body.decrease_life(1)
		destroy()
	elif (end):
		destroy()
	
func _on_RigidBody2D_body_enter_shape( body_id, body, body_shape, local_shape ):
	if global.sound:
		sound.play("bullet_sound", 0)
