extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const LIFE_TIME = 3


func _ready():
	var t = Timer.new()
	t.set_wait_time(LIFE_TIME)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	queue_free()
