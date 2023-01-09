extends Node


const LOOP_BG = preload("res://Audio/loop.wav")
const FOREST_BG = preload("res://Audio/forest.mp3")
const SPACE_BG = preload("res://Audio/space.mp3")
const TEXT_BG = preload("res://Audio/texts.mp3")
const RAIN_BG = preload("res://Audio/rain.mp3")
const SPACE_2_BG = preload("res://Audio/space2.mp3")
const ENDING_BG = preload("res://Audio/ending.mp3")


const TENSEC_FX = preload("res://Audio/10s.mp3")
const BREATH_FX = preload("res://Audio/light-breath.wav")
const WALK_FX = preload("res://Audio/walk.wav")
const NOTES = [
	preload("res://Audio/notes/6.wav"),
	preload("res://Audio/notes/5.wav"),
	preload("res://Audio/notes/4.wav"),
	preload("res://Audio/notes/3.wav"),
	preload("res://Audio/notes/2.wav"),
	preload("res://Audio/notes/1.wav"),
	preload("res://Audio/notes/0.wav"),
]
const ALARM_FX = preload("res://Audio/alarm.mp3")
const ZOOM_FX = preload("res://Audio/zoom.mp3")

var tween
var tween1

onready var BG = $BG
onready var FX = $FX


func _ready():
	pass


func _BG(file, vol=0.0, dur=2.0):
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if BG.playing:
		tween.tween_property(BG, "volume_db", -80.0, 1.0)
	else:
		BG.volume_db = -80.0
	tween.tween_callback(self, "set_stream", [BG, file])
	tween.tween_callback(self, "play_stream", [BG])
	tween.tween_property(BG, "volume_db", vol, dur)


func _FX(file, vol=.0, dur=.2, bus="FX"):
	if tween1: tween1.kill()
	tween1 = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
#	if FX.playing:
#		tween1.tween_property(FX, "volume_db", -50.0, .1)
	FX.bus = bus
	tween1.tween_callback(self, "set_stream", [FX, file])
	tween1.tween_callback(self, "play_stream", [FX])
	
	if dur != 0:
		FX.volume_db = -50.0
		tween1.tween_property(FX, "volume_db", vol, dur)


func _vol(audio, vol):
	audio.volume_db = vol


func vol_tween(audio, vol, dur):
	var tw := create_tween()
	tw.tween_property(audio, "volume_db", vol, dur)


func set_stream(audio, file):
	audio.stream = file

func play_stream(audio):
	audio.playing = true


func rand_note(vol=.0, dur=.2, bus="FX"):
	var n = randi()%NOTES.size()
	_FX(NOTES[n], vol, dur, bus)
