extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var level

func release_all():
	Input.action_release("ui_up")
	Input.action_release("ui_right")
	Input.action_release("ui_left")
	Input.action_release("ui_up")
	Input.action_release("ui_down")
	Input.action_release("ui_jump")
	Input.action_release("ui_shoot")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here	
	pass