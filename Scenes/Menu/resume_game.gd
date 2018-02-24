extends Button

func _on_Resume_pressed():
	get_tree().set_pause(false)
	get_parent().set_hidden(true)	

func _ready():
	set_process_input(true)

func _input(ev):
	if (ev.is_action_pressed("ui_cancel")):
		_on_Resume_pressed()		