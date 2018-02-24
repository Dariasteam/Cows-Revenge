extends Button

export(PackedScene) var scene

func _ready():
	connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():		
	get_tree().change_scene_to(scene)
