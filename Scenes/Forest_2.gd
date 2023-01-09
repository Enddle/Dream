extends Node


func _ready():
	Connect.sendudp("6")
	
	AuH._BG(AuH.RAIN_BG, .0, .0)
	$Forest.touch_enabled = true


func _process(delta):
	if randf() < 0.005:
		Connect.sendbang()
