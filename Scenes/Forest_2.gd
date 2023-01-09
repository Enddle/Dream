extends Node


func _ready():
	Connect.sendudp("6")
	
	AuH._BG(AuH.RAIN_BG, .0, .0)
	$Forest.touch_enabled = true
