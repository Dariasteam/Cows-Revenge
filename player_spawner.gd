extends Node2D

const PLAYER = preload("res://Scenes/Events/player.tscn")

func _ready():
	call_deferred("add_child", PLAYER.instance())
