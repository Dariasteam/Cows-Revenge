extends Button

export(PackedScene) var scene

func _ready():	
	set_process_input(true)		

func _on_Button_pressed():		
	get_tree().set_pause(false)
	get_tree().change_scene_to(scene)

func _input(ev):	
	if (ev.is_action_pressed("ui_cancel")):
		_on_Button_pressed()