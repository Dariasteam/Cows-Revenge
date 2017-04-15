extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# UP
func _on_Bttn_U_pressed():
	Input.action_press("ui_up")

func _on_Bttn_U_released():
	Input.action_release("ui_up")

# DOWN
func _on_Bttn_D_pressed():
	Input.action_press("ui_down")

func _on_Bttn_D_released():
	Input.action_release("ui_down")

# RIGHT
func _on_Bttn_R_pressed():
	Input.action_press("ui_right")

func _on_Bttn_R_released():
	Input.action_release("ui_right")

# LEFT
func _on_Bttn_L_pressed():
	Input.action_press("ui_left")

func _on_Bttn_L_released():
	Input.action_release("ui_left")

# JUMP
func _on_Bttn_A_pressed():
	Input.action_press("ui_jump")

func _on_Bttn_A_released():
	Input.action_release("ui_jump")


func _ready():
	pass

# DOWN_RIGHT
func _on_Bttn_DR_pressed():
	Input.action_press("ui_down")
	Input.action_press("ui_right")

func _on_Bttn_DR_released():
	Input.action_release("ui_right")
	Input.action_release("ui_down")

# DOWN_LEFT
func _on_Bttn_DL_pressed():
	Input.action_press("ui_down")
	Input.action_press("ui_left")

func _on_Bttn_DL_released():
	Input.action_release("ui_left")
	Input.action_release("ui_down")

# SHOOT
func _on_Bttn_S_pressed():
	Input.action_press("ui_shoot")

func _on_Bttn_S_released():
	Input.action_release("ui_shoot")

# MIX
func _on_Bttn_AS_pressed():
	Input.action_press("ui_jump")
	Input.action_press("ui_shoot")

func _on_Bttn_AS_released():
	Input.action_release("ui_jump")
	Input.action_release("ui_shoot")
