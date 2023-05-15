extends Node

var nextThunder = 0

func _ready():
	Connect.sendudp("6")
	Connect.sendextra("0")
	
	AuH._BG(AuH.RAIN_BG, .0, .0)
	$Forest.touch_enabled = true


func _process(delta):
	if randf() < 0.005 && Time.get_ticks_msec() > nextThunder:
		nextThunder = Time.get_ticks_msec() + 350
		Connect.sendbang()
