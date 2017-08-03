extends Node2D

# UP
func _on_Bttn_U_pressed():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_up", true)
	get_node("Control/Viewport").input(a)
	
	#Input.action_press("ui_up")

func _on_Bttn_U_released():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_up", false)
	get_node("Control/Viewport").input(a)
	
	#Input.action_release("ui_up")

# DOWN
func _on_Bttn_D_pressed():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_down", true)
	get_node("Control/Viewport").input(a)
	
	#Input.action_press("ui_down")

func _on_Bttn_D_released():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_down", false)
	get_node("Control/Viewport").input(a)
	
	#Input.action_release("ui_down")

# RIGHT
func _on_Bttn_R_pressed():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_right", true)
	get_node("Control/Viewport").input(a)
	
	#Input.action_press("ui_right")

func _on_Bttn_R_released():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_right", false)
	get_node("Control/Viewport").input(a)
	
	#Input.action_release("ui_right")

# LEFT
func _on_Bttn_L_pressed():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_left", true)
	get_node("Control/Viewport").input(a)
	
	
	#Input.action_press("ui_left")

func _on_Bttn_L_released():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_left", false)
	get_node("Control/Viewport").input(a)
	
	#Input.action_release("ui_left")

# JUMP
func _on_Bttn_A_pressed():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_jump", true)
	get_node("Control/Viewport").input(a)
	
	#Input.action_press("ui_jump")

func _on_Bttn_A_released():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_jump", false)
	get_node("Control/Viewport").input(a)
	
	#Input.action_release("ui_jump")

# DOWN_RIGHT
func _on_Bttn_DR_pressed():
	_on_Bttn_D_pressed()
	_on_Bttn_R_pressed()

func _on_Bttn_DR_released():
	_on_Bttn_D_released()
	_on_Bttn_R_released()

# DOWN_LEFT
func _on_Bttn_DL_pressed():
	_on_Bttn_D_pressed()
	_on_Bttn_L_pressed()

func _on_Bttn_DL_released():
	_on_Bttn_D_released()
	_on_Bttn_L_released()

# SHOOT
func _on_Bttn_S_pressed():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_shoot", true)
	get_node("Control/Viewport").input(a)
	
	#Input.action_press("ui_shoot")

func _on_Bttn_S_released():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_shoot", false)
	get_node("Control/Viewport").input(a)
	
	#Input.action_release("ui_shoot")

# MIX
func _on_Bttn_AS_pressed():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_change_weapon", true)
	get_node("Control/Viewport").input(a)
	
	#Input.action_press("ui_change_weapon")

func _on_Bttn_AS_released():
	var a = InputEvent()
	a.type = InputEvent.ACTION
	a.set_as_action("ui_change_weapon", false)
	get_node("Control/Viewport").input(a)
	
	#Input.action_release("ui_change_weapon")