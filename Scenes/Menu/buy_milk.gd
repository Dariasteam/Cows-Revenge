extends Button

var price = 0

func _ready():	
	update_price()

func update_price():
	price = global.base_price_milk * max(global.increment_price_milk * global.milk_buyed, 1)	
	get_node("Milk_Label").set_text(str(price))	
	if (price < global.saved_cowbells):
		set_disabled(false)
	else:
		set_disabled(true)

func _on_Milk_button_pressed():
	global.buy_milk(price)
	update_price()
