extends Button

var price = 0

func _ready():	
	update_price()	

func update_price():
	price = global.base_price_heart * max(global.increment_price_heart * global.hearts_buyed, 1)
	get_node("Heart_Label").set_text(str(price))
	if (price < global.saved_cowbells):
		set_disabled(false)
	else:
		set_disabled(true)		

func _on_Heart_button_pressed():
	global.buy_heart(price)
	update_price()
	
