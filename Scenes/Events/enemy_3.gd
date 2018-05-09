extends Node2D

onready var hand_1 = get_node("Hand_Back/End")
onready var hand_2 = get_node("Hand_Front/End")

func _ready():
	set_process(true)
	
func _process(delta):
	var player = get_tree().get_nodes_in_group("player")[0]	
	
	if (player.get_global_pos().distance_to(get_global_pos()) < 100):
		hand_1.set_global_pos(player.get_global_pos())
		
	if (player.get_global_pos().distance_to(get_global_pos()) < 100):
		hand_2.set_global_pos(player.get_global_pos())
	