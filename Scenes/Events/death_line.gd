extends Area2D

onready var particles = get_tree().get_nodes_in_group("bottom_level_particles")[0]
func _on_DeathLine_body_enter( body ):
	if(body.is_in_group("player")):
		body.on_receive_damage(1000)
	elif(body.is_in_group("enemy")):
		body.queue_free()	


func _on_death_line_area_enter( area ):
	if(area.is_in_group("bottom_level_detector")):		
		particles.set_emitting(true)		

func _on_death_line_area_exit( area ):
	if(area.is_in_group("bottom_level_detector")):
		particles.set_emitting(false)
