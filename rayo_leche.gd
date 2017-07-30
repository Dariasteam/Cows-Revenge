extends RayCast2D

onready var middle = get_node("middle")
onready var end = get_node("end")
onready var origin = get_node("origin")

export var damage = 10

var enabled = false
const MAX_DISTANCE = 10000
var distance = MAX_DISTANCE

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

func _ready():
	set_fixed_process(true)
	
func enable():
	force_raycast_update()
	end.set_emitting(true)
	origin.set_emitting(true)
	enabled = true
	
func disable():
	origin.set_emitting(false)
	end.set_emitting(false)
	enabled = false
	middle.set_region_rect(Rect2(Vector2(0,0),Vector2(0,0)))
	end.set_global_pos(get_global_pos())

func calc_shoot():
	set_cast_to(Vector2(distance, 0))
	var end_point
	if (is_colliding()):
		end_point = Vector2 (  get_global_pos().distance_to(get_collision_point()), 29)
	else:
		end_point = Vector2 (distance, 29)
			
	middle.set_region_rect(Rect2(get_pos(),end_point))
	end.set_global_pos(get_collision_point())
	origin.set_pos(get_pos())

func _fixed_process(delta):
	if (enabled):
		calc_shoot()