extends Node

const MENU_MUSIC = preload ("res://Music/dangerous_hills.ogg")

var base_price_heart = 500
var base_price_milk = 500

var increment_price_heart = 2
var increment_price_milk = 2

var hearts_buyed = 0
var milk_buyed = 0

var level = 0
var unlocked_levels = 1
var onscreen_controls = true
var cowbells = 0
var life = 3
var milk_level = 0
var max_milk = 100
var max_life = 3
var saved_cowbells = 0

func buy_milk(price):
	milk_buyed += 1
	saved_cowbells -= price
	max_milk += 33	
	get_tree().get_nodes_in_group("level_selector")[0].reset_hud()
	save_game()
	
func buy_heart(price):
	hearts_buyed += 1
	saved_cowbells -= price
	max_life += 1	
	get_tree().get_nodes_in_group("level_selector")[0].reset_hud()
	save_game()

func release_all():
	pass

func _ready():
	load_game()	
	
func toggle_on_screen_buttons(pressed):
	onscreen_controls = pressed	
	save_game()

func save_cowbells():
	saved_cowbells = cowbells
	save_game()

func reset_player():	
	global.life = global.max_life
	milk_level = 0
	cowbells = saved_cowbells

func save_game(): 
	print ("saving")
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var data = {
		unlocked_levels=unlocked_levels,
		onscreen_controls=onscreen_controls,
		saved_cowbells = saved_cowbells,
		max_milk = max_milk,		
		max_life = max_life,
		life = life,
		milk_buyed = milk_buyed,
		hearts_buyed = hearts_buyed
	}
	save_game.store_line(data.to_json())
	save_game.close()	
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error!  We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)		
	
	print ("Load save")
	var current_line = {}	
	
	current_line.parse_json(save_game.get_line())	
	unlocked_levels = current_line["unlocked_levels"]	
	onscreen_controls = current_line["onscreen_controls"]
	cowbells = current_line["saved_cowbells"]
	saved_cowbells = cowbells
	
	max_milk = current_line["max_milk"]	
	max_life = current_line["max_life"]
	life = current_line["life"]
	milk_buyed = current_line["milk_buyed"]
	hearts_buyed = current_line["hearts_buyed"]
	
	