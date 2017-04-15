extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func on_Bttn_press():
	get_tree().change_scene("res://All.tscn")

func _ready():
	connect("pressed", self, "on_Bttn_press")
	# Called every time the node is added to the scene.
	# Initialization here
	pass
