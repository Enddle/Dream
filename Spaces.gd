extends Control

var scene_out = false

func _ready():
	SceneHelper.isSpaces = true
	SceneHelper.rounds = 0


func _on_room_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.fade_to_black(1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	SceneHelper.isTutorial = false
	get_tree().change_scene_to_file("res://Scenes/Room.tscn")


func _on_forest_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.fade_to_black(1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	SceneHelper.isTutorial = false
	get_tree().change_scene_to_file("res://Scenes/Forest_1.tscn")


func _on_stars_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.fade_to_black(1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	SceneHelper.isTutorial = false
	get_tree().change_scene_to_file("res://Scenes/Stars3D.tscn")


func _on_textout_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.fade_to_black(1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	SceneHelper.isTutorial = false
	get_tree().change_scene_to_file("res://Scenes/TextOut.tscn")


func _on_textin_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.rounds = 1
	
	SceneHelper.fade_to_black(1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	SceneHelper.isTutorial = false
	get_tree().change_scene_to_file("res://Scenes/TextIn.tscn")


func _on_lightning_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.fade_to_black(1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	SceneHelper.isTutorial = false
	get_tree().change_scene_to_file("res://Scenes/Spaces/LightningControl.tscn")


func _on_exit_pressed():
	if scene_out: return
	scene_out = true
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	
	SceneHelper.isSpaces = false
	
	SceneHelper.fade_to_black(1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	SceneHelper.isTutorial = false
	get_tree().change_scene_to_file("res://StartingScreen.tscn")
