extends StreamPlayer

func _ready():	
	if global.music:
		play(0)
