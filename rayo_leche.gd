extends RayCast2D

onready var middle = get_node("middle")
onready var end = get_node("end")
onready var origin = get_node("origin")

export var damage = 10

var enabled = false
const MAX_DISTANCE = 100000
var distance = MAX_DISTANCE

func look_left():	
	distance = -MAX_DISTANCE
	middle.set_rot(PI)
	
func look_right():	
	distance = MAX_DISTANCE
	middle.set_rot(0)

func _ready():
	set_fixed_process(true)
	
func enable():
	enabled = true
	
func disable():
	enabled = false
	middle.set_region_rect(Rect2(Vector2(0,0),Vector2(0,0)))
	end.set_global_pos(get_global_pos())

func _fixed_process(delta):
	if (enabled):
		set_cast_to(Vector2(distance, 0))
		var end_point = Vector2 (abs(get_global_pos().x - get_collision_point().x) * 2, 15)
		middle.set_region_rect(Rect2(get_pos(),end_point))
		end.set_global_pos(get_collision_point())
		origin.set_pos(get_pos())