extends Node2D


const color_seqs = [
	[
		[Color.BLACK,     8],
		[Color.DARK_GRAY,  5],
	],
	[
		[Color.DARK_RED,   1],
	],
	[
		[Color.DARK_BLUE,  1],
		[Color.DARK_GRAY,  5],
	],
	[
		[Color.BLACK,     3],
	],
]


var tween
var current_seq = 0


func _ready():
	modulate = Color.BLACK


func start_seq(seq):
	if seq >= color_seqs.size():
		return
	
	current_seq = seq
	if tween: tween.kill()
	tween = create_tween()
	var n = 0
	for c in color_seqs[seq]:
		tween.tween_property(self, "modulate", c[0], c[1])
		tween.tween_callback(Callable(self, "seq_step").bind(seq, n))
		n += 1
	tween.tween_callback(Callable(self, "seq_step").bind(seq, -1))
#	print("Dynamic Color seq " + String(seq) + " starts")


func seq_step(_seq, step):
	if step == -1:
#		print("Dynamic Color seq " + String(seq) + " finished")
		return
#	print("Dynamic Color seq " + String(seq) + " step " + String(step) + " finished")


func color_gr(percent, a) -> Color:
	var c = modulate
	c.r *= percent
	c.g *= percent
	c.b *= percent
	c.a = a
	return c
