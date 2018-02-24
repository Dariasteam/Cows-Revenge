extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const BONUS = preload("res://Scenes/Events/cowbell_bonus.tscn")

onready var label = get_node("Counter")
onready var animation = get_node("Sprite/Animation")
onready var next_cowbell_timer = get_node("next_cowbell_timer")
onready var cold_down_timer = get_node("cold_down_timer")
onready var sprite = get_node("Sprite")
onready var base_modulation = Color(1,1,1)
onready var instancer = get_node("bonus_instancer")

var frame_number

func reset_values():
	set_counter(global.saved_cowbells, 0)

func bonus(quantity):
	var bonus = BONUS.instance()
	bonus.set_text(str("+",quantity))	
	instancer.add_child(bonus)	

func _ready():	
	animation.play("cowbell_animations")
	var anim = animation.get_animation("cowbell_animations")
	next_cowbell_timer.set_wait_time(anim.get_length() / animation.get_speed() )
	set_counter(global.cowbells, 0)
	animation.set_active(false)		

func set_counter (var quantity, var acumulated):	
	sprite.set_modulate(Color (1,1 - acumulated * 2,1 - acumulated * 2))
	label.set_bbcode(" " + String(quantity))
	animation.set_active(true)	
	next_cowbell_timer.start()
	cold_down_timer.start()
	

func _on_next_cowbell_timer_timeout():
	sprite.set_frame(0)
	animation.set_active(false)
	
func _on_cold_down_timer_timeout():
	var current_modulation = sprite.get_modulate()	
	if (current_modulation.g >= base_modulation.g && current_modulation.b >= base_modulation.b):
		sprite.set_modulate(base_modulation)
		cold_down_timer.stop()		
	else:		
		sprite.set_modulate(Color (1,current_modulation.g + 0.02 ,current_modulation.b + 0.02))		
