extends "res://Scenes/Ext/Rotate3D.gd"


const textnode = preload("res://src/Text.tscn")


const texts_en = [
	"Ding, ding, ding\nThe alarm goes off, oh\nIt's a dream",
	"I was trapped\ninside of a small white room\nbut my mind is free\n \nand now\nI am free"
]
const delays_en = [
	[
		[14, 1.2],	# ding^
		[17, -.08],	# The^
		[26, -.08],	# goes^
		[29, .8],	# off^
		[32, 2.0],	# oh^
		[36, .5],	# 's^
		[37, -.08],	# a^dr
	],
	[
		[11, 3.0],	# pped^
		[17, -.08],	# side^
		[34, 5.0],	# room^
		[39, -.08],	# my^
		[49, 10.0],	# free^
		[52, -.08],	# and^
		[55, 3.0],	# now^
	]
]
const text_size_en = .7
const extra_height_en = 1.0
const delay_def_en = .1

const texts_jp = [
	"...\nアラームが鳴ってる\n夢みたいだ",
	"狭い白い部屋の中に\n閉じ込められていても\nどこにでも行ける\n \nこれで\n自由に..."
]
const delays_jp = [
	[
		[1, 1.0],	# .^
		[2, 1.0],	# .^
		[3, 1.6],	# .^
		[12, 1.6],	# る^
		[13, .5],	# 夢^
	],
	[
		[2, .5],		# 狭い^
		[9, 1.6],	# 中に^
		[19, 1.6],	# ても^
		[24, .5],	# でも^
		[27, 10.0],	# る^
		[30, 1.5],	# で^
		[33, 1.0],	# ^.
		[34, 1.0],	# ^.
		[35, 1.0],	# ^.
	]
]
const text_size_jp = 1.5
const extra_height_jp = .0
const delay_def_jp = .15

var texts = texts_jp
var delays = delays_jp

var text_size = text_size_jp
var extra_height = extra_height_jp
var delay_def = delay_def_jp

const round0_outtime = 20
const round1_outtime = 40
const round1_delay = 32

var triggered = false
var scene_out = false
var timestart
var rounds
var delay_n = 0

onready var text_con = $World/Texts


func _ready():
	
<<<<<<< Updated upstream
=======
	language_prep()
	
>>>>>>> Stashed changes
	if SceneHelper.isSpaces:
		$exit.visible = true
	
	$Anim.play("arrow_indicate")
	indicator_show = true
	
	randomize()
	timestart = OS.get_ticks_msec() / 1000
	DynamicColor.start_seq(0)
	
	rounds = SceneHelper.rounds
	process_text(rounds)
	
	if rounds == 0:
		Connect.sendudp("4")
		Connect.sendextra("1")
		AuH._FX(AuH.ALARM_FX)
		yield(get_tree().create_timer(2), "timeout")
		AuH._BG(AuH.TEXT_BG, .0, .5)
	else:
		Connect.sendudp("8")


var sec = 0


func _process(delta):
	
	var time = OS.get_ticks_msec() / 1000
	
	if rounds == 0:
		if time - timestart > round0_outtime:
			scene_out = true
			indicator_show = false
			next_scene()
			
		elif time - timestart > 15 && !triggered:  # text fly out
			triggered = true
			for c in text_con.get_children():
				c.update_center()
				
	elif rounds == 1:
		if time - timestart > round1_outtime:
			scene_out = true
			indicator_show = false
			DynamicColor.start_seq(1)
			TA.hold_end()
			
			yield(get_tree().create_timer(round1_delay), "timeout")
			
			Connect.sendudp("-2")
			
			end_scenes()
			
		elif time - timestart > 20 && !triggered:  # text fly out
			triggered = true
			for c in text_con.get_children():
				c.update_center()


func process_text(n):
	var lines = texts[n].split("\n")
	var cc = 0
	
	if (n == 1):
		yield(get_tree().create_timer(2), "timeout")
	
	var line_height = lines.size() * (text_size + extra_height)
	for r in lines.size():
		
		var line = lines[r]
		var line_width = line.length() * text_size
		for c in lines[r].length():
			
			var chara = lines[r][c]
			if chara == " ":
				yield(get_tree().create_timer(delay_def), "timeout")
				continue
			
			var x = -line_width / 2 + c * text_size
			var y = line_height / 2 - r * (text_size + extra_height)
			var pos = Vector3(x, y, -8)
#			print(chara + " -at position: " + String(pos))
			
			# delay
			yield(get_tree().create_timer(get_delay(n, cc) + delay_def), "timeout")
			cc += 1
			
			var t = textnode.instance()
			t.init(chara, pos)
			text_con.add_child(t)


func get_delay(n, cc) -> float:
	if delay_n >= delays[n].size():
		return 0.0
	
	var current_delay = delays[n][delay_n]
	if cc == current_delay[0]:
		delay_n += 1
		return current_delay[1]
	return 0.0


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
#		print("Mouse Click at: ", event.position)
		
		if scene_out: return
		DynamicColor.start_seq(1)
		TA.hold_start(event.position)

	if event is InputEventMouseButton and !event.is_pressed():
#		print("Mouse Unclick at: ", event.position)
		
		if scene_out: return
		DynamicColor.start_seq(2)
		TA.hold_end()


func next_scene():
	DynamicColor.start_seq(3)
	TA.hold_end()
	
	Connect.sendextra("0")
	
	yield(get_tree().create_timer(12.0), "timeout")
	SceneHelper.fade_to_black(1.0, 0.05)
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Scenes/TextOut.tscn")

func end_scenes():
	get_tree().change_scene("res://EndCredits.tscn")
	pass


func _on_exit_pressed():
	AuH.rand_note(rand_range(-20, 0), .0, "Reverb")
	get_tree().change_scene("res://Spaces.tscn")
<<<<<<< Updated upstream
=======


func language_prep():
	match SceneHelper.lang_curr:
		SceneHelper.LANG_JP:
			texts = texts_jp
			delays = delays_jp
			text_size = text_size_jp
			extra_height = extra_height_jp
			delay_def = delay_def_jp
		SceneHelper.LANG_EN:
			texts = texts_en
			delays = delays_en
			text_size = text_size_en
			extra_height = extra_height_en
			delay_def = delay_def_en
>>>>>>> Stashed changes
