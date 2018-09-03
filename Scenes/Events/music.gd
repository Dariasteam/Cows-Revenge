extends StreamPlayer

func _ready():
	print (global.music)
	if global.music:
		play(0)
