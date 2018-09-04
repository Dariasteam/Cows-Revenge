extends RayCast2D

onready var middle = get_node("middle")
onready var end = get_node("end")
onready var origin = get_node("origin")

onready var sound = get_node("sound")

var player

export var damage = 120

var enabled = false
const MAX_DISTANCE = 10000
var distance = MAX_DISTANCE

func set_player(p):
	player = p

func look_left():
	force_raycast_update()
	distance = -MAX_DISTANCE
	origin.set_param(Particles2D.PARAM_DIRECTION, 270)
	middle.set_region_rect(Rect2(Vector2(0,0),Vector2(0,0)))
	middle.set_rot(PI)
	
func look_right():
	force_raycast_update()
	distance = MAX_DISTANCE
	origin.set_param(Particles2D.PARAM_DIRECTION, 90)
	middle.set_region_rect(Rect2(Vector2(0,0),Vector2(0,0)))
	middle.set_rot(0)
	
func enable():
	force_raycast_update()
	end.set_emitting(true)
	end.get_node("Area2D").enable()
	origin.set_emitting(true)
	middle.set_opacity(1)
	if global.sound:
		sound.play()
	set_process(true)
	
func disable():
	origin.set_emitting(false)
	end.set_emitting(false)
	end.get_node("Area2D").disable()
	middle.set_opacity(0)
	if global.sound:
		sound.stop()
	set_process(false)
	
func _process(delta):
	set_cast_to(Vector2(distance, 0))
	var end_point
	
	if (is_colliding()):
		end_point = Vector2 (get_global_pos().distance_to(get_collision_point()), 29)
		end.set_emitting(true)
	else:
		end_point = Vector2 (distance, 29)
		end.set_emitting(false)
			
	middle.set_region_rect(Rect2(get_pos(),end_point))
	end.set_global_pos(get_collision_point())
	origin.set_pos(get_pos())


