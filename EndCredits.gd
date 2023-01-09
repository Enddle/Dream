extends Node


const credits = [
	"「DREAM」\n\n\nZHENG JIANHAO　ズン ジアンハオ",
	"武蔵野美術大学　映像学科\n\n\n三年次進級制作展",
	"\n\nシャルルゼミ\n",
	"\n\nご視聴ありがとうございます!\n"
]


func _ready():
	SceneHelper.isCredit = true
	
	$Label.text = ""
	$Label2.modulate.a = 0.0
	yield(get_tree().create_timer(5), "timeout")
	AuH._BG(AuH.ENDING_BG, 3.0, .0)
	yield(get_tree().create_timer(.2), "timeout")
	$Label.text = credits[0]
	yield(get_tree().create_timer(4.0), "timeout")
	$Label.text = credits[1]
	yield(get_tree().create_timer(2.0), "timeout")
	$Label.text = credits[2]
	yield(get_tree().create_timer(2.0), "timeout")
	$Label.text = ""
	yield(get_tree().create_timer(2.0), "timeout")
	
	var tween := create_tween()
	tween.tween_property($Label2, "modulate:a", 1.0, 2.0)
	tween.tween_property($Label2, "modulate:a", 0.0, 6.0).set_delay(8.0)
	
	yield(get_tree().create_timer(21.0), "timeout")
	$Label.text = credits[3]
	yield(get_tree().create_timer(2.0), "timeout")
	SceneHelper.fade_to_black(4.0, 2.0)
	
	yield(get_tree().create_timer(4.0), "timeout")
	SceneHelper.isCredit = false
	get_tree().change_scene("res://StartingScreen.tscn")
