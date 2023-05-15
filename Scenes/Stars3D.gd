extends "res://Scenes/Ext/Rotate3D.gd"

const star = preload("res://src/Star.tscn")

var accel = Vector3.ZERO
var speed = Vector3.ZERO
var timetick
var laststar

var scene_out = false

@onready var pointer = $Camera3D/Node3D/Pointer
@onready var star_con = $World/Stars


func _ready():
	randomize()
	timetick = Time.get_ticks_msec() / 1000
	laststar = timetick - 1
	
	Connect.resetbang()
	
	if SceneHelper.isSpaces:
		$exit.visible = true
		Connect.sendudp("3")
	
	elif SceneHelper.rounds == 0:
		AuH._BG(AuH.SPACE_BG)
		Connect.sendudp("3")
		
	elif SceneHelper.rounds == 1:
		AuH._BG(AuH.SPACE_2_BG)
		Connect.sendudp("7")
		Connect.sendextra("0")


func _process(delta):
	if scene_out:
		return
	
	if !SceneHelper.isSpaces and Time.get_ticks_msec() / 1000 - timetick > 30:
		next_scene()
		scene_out = true
	
	accel = Vector3(randf()-.5, randf()-.5, randf()-.5) * 10
	if pointer.position.distance_squared_to(Vector3.ZERO) > 0.75:
		accel -= pointer.position.normalized() * 5
	speed += .5 * accel * delta
	pointer.translate(speed * delta * 2)


func _input(event):
	if event is InputEventMouseButton and !event.is_pressed():
#		print("Mouse Unclick at: ", event.position)
		if can_add_star:
			can_add_star = false
			TA.touch(event.position)
			add_star()
			$add_star_timer.start()


var can_add_star = true

func _on_add_star_timeout():
	can_add_star = true


func add_star():
	var s = star.instantiate()
	var t = pointer.global_transform
	star_con.add_child(s)
	s.global_transform = t
	
	Connect.sendbang()
	
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")


func next_scene():
	if SceneHelper.rounds == 1:
		var tween := create_tween()
		tween.tween_property(pointer, "global_position", Vector3.ZERO, 5.0)
		await get_tree().create_timer(3).timeout
		await get_tree().create_timer(1).timeout
		
		Connect.sendextra("1")
		
		SceneHelper.fade_to(Color.WHITE, 1.0, 3.0)
		
		await get_tree().create_timer(.75).timeout
		
		AuH._FX(AuH.ZOOM_FX, .0, .0)
		
		await get_tree().create_timer(.25).timeout
	
	if SceneHelper.isSpaces:
		get_tree().change_scene_to_file("res://Spaces.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/TextIn.tscn")


func _on_exit_pressed():
	next_scene()
