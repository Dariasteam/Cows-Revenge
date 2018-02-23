extends Area2D

export(String, MULTILINE) var text

func _on_Area2D_body_enter( body):
	if (body.is_in_group("player")):
		get_node("Text").set_text(text)
		get_node("Text/AnimationPlayer").play("Apear")
		get_node("CollisionShape2D").queue_free()
