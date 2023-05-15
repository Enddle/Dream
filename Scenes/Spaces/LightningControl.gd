extends Node

var nextThunder = 0
var scene_out = false


func _ready():
	Connect.sendudp('6')

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
#		print("Mouse Click at: ", event.position)
		pass
	if event is InputEventMouseButton and !event.is_pressed():
#		print("Mouse Unclick at: ", event.position)
		if OS.get_ticks_msec() > nextThunder:
			nextThunder = OS.get_ticks_msec() + 500
#			print("Thunder at: ", event.position.x / 2266)
			
			TA.touch(event.position)
			
			Connect.sendextra(event.position.x / 2266)
			Connect.sendbang()


func _on_exit_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(rand_range(-20, 0), .0, "Reverb")
	
	SceneHelper.fade_to_black(1, 1)
	yield(get_tree().create_timer(1), "timeout")
	SceneHelper.isStarting = false
	get_tree().change_scene("res://Spaces.tscn")
