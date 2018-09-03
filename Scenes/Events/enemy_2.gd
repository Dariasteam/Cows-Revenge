extends KinematicBody2D

const GRAVITY = 3000.0

var vertical
export var velocity = 350
var v = Vector2(-velocity, 0)

const MACHETE = preload("res://Scenes/Events/machete.tscn") 

onready var sprite = get_node("sprite")
onready var area_head = get_node("area_head")
onready var hit_single = get_node("hit_ray_particle")
onready var sound = get_node("sound")
onready var shooter = get_node("shooter")
onready var shooter_pos = get_node("shooter").get_pos()

export(bool) var dir_left = true;

export(int) var life = 2

export(int) var damage = 1

func reverse_direction():
	sprite.set_flip_h(v.x < 0)
	dir_left = !dir_left
	v = Vector2(-v.x,0)	
	shooter.set_pos(Vector2(-shooter_pos.x, shooter_pos.y))

func _ready():	
	if (!dir_left):
		reverse_direction()
	#set_fixed_process(true)
	set_process(true)

func disappear():
	get_node("shooter/Timer").disconnect("timeout", self, "_on_Timer_timeout")
	play_damage_sound()
	sprite.set_opacity(0)
	set_fixed_process(false)
	set_layer_mask_bit(2,false)

	hit_single.set_emitting(true)
	var t = Timer.new()
	t.set_wait_time(max(hit_single.get_lifetime(), 1))
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	queue_free()

func die_by_jump():
	life = 0
	disappear()

func die():
	disappear()

func on_opacity_low ():
	sprite.set_modulate(Color("fb12e7"))

func on_opacity_high ():
	sprite.set_modulate(Color("00ffff"))

func play_damage_sound():
	var sample_list = sound.get_sample_library().get_sample_list()
	var sample = sample_list[rand_range(0, sample_list.size())]
	if global.sound:
		sound.play(sample, 0)

func decrease_life (value):
	play_damage_sound()
	hit_single.set_emitting(false)
	hit_single.set_emitting(true)
	var t1 = Timer.new()
	var t2 = Timer.new()
	t1.set_wait_time(0.07)
	t2.set_wait_time(0.07)
	t1.set_one_shot(true)
	t2.set_one_shot(true)
	t1.connect("timeout",self,"on_opacity_low")
	t2.connect("timeout",self,"on_opacity_high")
	add_child(t1)
	add_child(t2)
	t1.start()
	yield(t1, "timeout")
	t2.start()
	yield(t2, "timeout")
	sprite.set_modulate(Color("ffffff"))
	if (life > 0):
		life -= value
		if (life <= 0):
			die()

func restore_velocity():
	if(dir_left):
		v.x = -velocity
	else:
		v.x = velocity

func change_velocity(amount, right):
	if (right == dir_left):
		v.x = ((!dir_left * -1) + (dir_left * 1)) * amount
	else:
		v.x += ((dir_left * -1) + (!dir_left * 1)) * amount


func _process(delta):
	var motion = v * delta
	motion = move(motion)
	v.y += delta * GRAVITY

	if (is_colliding()):
		var normal = get_collision_normal();

		if (normal.y < 0):
			if (normal.y > -1):
				v.y = -velocity
			var aux = v.x
			motion = normal.slide(motion)
			v = normal.slide(v)
			move(motion)
			v.x = aux
		if (normal.x < -0.9 or normal.x > 0.9):
			reverse_direction()

func _on_area_body_body_enter( body ):
	if (body.is_in_group("player") and life > 0):
		body.on_receive_damage(damage)

func _on_area_head_body_enter( body ):
	if (body.is_in_group("player")):
		if (body.foots.get_global_pos().y > area_head.get_global_pos().y and body.is_falling()):
			life = 0
			die_by_jump()

func _on_Timer_timeout():
	var machete = MACHETE.instance()
	machete.set_global_pos(shooter.get_global_pos())
	machete.set_right(!dir_left)
	get_parent().add_child(machete)	
