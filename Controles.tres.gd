extends Node2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _on_button_pressed():
    pritn("asd")

func _ready():
    get_node("Bttn_U").connect("pressed",self,"_on_button_pressed")
