extends RayCast2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	if (is_colliding()):
		print ("Colliding")
	else:
		print ("Not colliding")
