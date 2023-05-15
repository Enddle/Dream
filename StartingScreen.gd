extends Control


var tween
var scene_out = false


func _ready():
	Connect.sendudp("0")
	Connect.sendextra("0")
	Connect.resetbang()
	
	SceneHelper.rounds = 0
	SceneHelper.isSpaces = false
	SceneHelper.isStarting = true
	SceneHelper.scene_out = false
	
	AuH._BG(AuH.LOOP_BG, -6.0, 5.0)


func start_tutorial():
	SceneHelper.fade_to_black(1, 1)
	await get_tree().create_timer(1).timeout
	SceneHelper.isStarting = false
	get_tree().change_scene_to_file("res://Tutorial.tscn")


func _on_Button_button_down():
	$Label2.text = AudioServer.device
	$Label2.text += "\n\n"
	for d in AudioServer.get_output_device_list():
		$Label2.text += d
		$Label2.text += "\n"
	pass # Replace with function body.


func _on_settings_pressed():
	SceneHelper.settings_open()


func _on_story_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	start_tutorial()


func _on_space_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.fade_to_black(1, 1)
	await get_tree().create_timer(1).timeout
	SceneHelper.isStarting = false
	get_tree().change_scene_to_file("res://Spaces.tscn")

