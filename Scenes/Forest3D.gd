extends "res://Scenes/Ext/Camera3D.gd"

const init_tree_count = 32
const add_tree_rate = .7

const step_speed_const = 4.0
const step_dura_const = .8
const tree_sprite = preload("res://src/trees/Tree.tscn")

var moving = false
var tween
var step_allowed = true
var step_speed = 3.0
var step_dura = 1.0
var steps = 20
var step_left = 1

var scene_out = false

onready var tree_con = $World/trees
onready var leaf_bg = $World/leaf_bg


func _ready():
	randomize()
	
	random_trees_all()
	
	for x in AudioServer.get_device_list():
		$Label.text += x + '\n'


func random_trees_all():
#	if tween: tween.kill()
#	tree_con.translation = Vector3.ZERO
#	world.translation = Vector3.ZERO
	
	for child in tree_con.get_children():
		child.queue_free()
	
	random_trees_init(init_tree_count)


func random_trees_init(amount):
	for n in (amount / 4):
		for i in 2:
			for j in 2:
				random_tree_init(i == 0, j == 0)


func random_tree_init(invx, invz):
	var randx = rand_range(1, 60)
	var randz = rand_range(1, 60)
	if invx: randx = -randx
	if invz: randz = -randz
	var randpos = Vector3(randx, 0, randz)
	
	add_tree_at(randpos)


func random_tree_front():
	# get random position around the circle (r: 80)
	var randx = rand_range(-25, 25)
	var z = -sqrt(6400.0 - randx * randx)
	var randpos = Vector3(randx, 0, z)
	
#	# apply cam direction and trees translation  # removed: using global trans
#	var camdir = cam.transform.basis.z
#	camdir.y = 0
#	var rot = Vector3.BACK.angle_to(camdir)
#	if camdir.x < 0: rot *= -1
#	randpos = randpos.rotated(Vector3.UP, rot)
#	randpos -= tree_con.translation
	
	add_tree_at(randpos)


func add_tree_at(pos):
	var tree = tree_sprite.instance()
	tree_con.add_child(tree)
	tree.global_translation = pos


var touch_enabled = false

func _input(event):
	if touch_enabled and event is InputEventMouseButton and !event.is_pressed():
#		print("Mouse Unclick at: ", event.position)
		
		if !step_allowed: return
		
		AuH._FX(AuH.WALK_FX)
		TA.touch(event.position)
		
		walk_step()
		steps -= 1
		if steps < 0:
			if step_speed > 5.8:
				next_scene()
			elif step_speed < 4.0:
				Hint.show_hint("もっと速く走る。", false, false)
		
		if randf() < add_tree_rate: return
		random_tree_front()


func walk_step():
	if !step_allowed: return
	step_allowed = false
	
	# get cam direction, exclude y axis
	var dir = cam.transform.basis.z
	dir.y = .0
	
	# speed up when step continues
	if step_speed < 6: step_speed += .1
	if step_dura > 0.2: step_dura -= .05
	# skip step down and skip reset speed
	if tween: tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# move towards direction at speed
	tween.tween_property(tree_con, "translation", dir * step_speed, step_dura).as_relative()
	tween.parallel().tween_property(leaf_bg, "translation", dir * step_speed, step_dura).as_relative()
	# body move up from step up
	tween.parallel().tween_property(world, "global_translation:y", -.8, step_dura / 2)
	# body move left / right
	step_left *= -1
	tween.parallel().tween_property(world, "translation:x", .8 * step_left, step_dura)
	# step finished, can skip later animations
	tween.tween_callback(self, "allow_step")
	
	# body move down from step down
	tween.tween_property(world, "translation:y", .0, .4)
	# reset speed when stops after a delay
	tween.tween_callback(self, "reset_step").set_delay(.5)

func allow_step():
	leaf_bg.global_translation.x = fmod(leaf_bg.global_translation.x, 5.26)
	leaf_bg.global_translation.z = fmod(leaf_bg.global_translation.z, 3.505)
#	print(leaf_bg.global_translation.z)
	step_allowed = true

func reset_step():
	step_speed = step_speed_const
	step_dura = step_dura_const


func next_scene():
	if scene_out: return
	scene_out = true
	
	if SceneHelper.isSpaces:
		SceneHelper.fade_to_black(1, 1)
		yield(get_tree().create_timer(1), "timeout")
		SceneHelper.isStarting = false
		get_tree().change_scene("res://Spaces.tscn")
	else:
		get_tree().change_scene("res://Scenes/Stars3D.tscn")
