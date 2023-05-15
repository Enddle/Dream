extends Node


const credits = [
	"「DREAM」\n\n\nZHENG JIANHAO　ズン ジアンハオ",
	"Pratt Institute\n\n\nDepartment of Digital Arts",
	"武蔵野美術大学\n\n\n映像学科",
	"\n\nご視聴ありがとうございます!\n"
]


func _ready():
	SceneHelper.isCredit = true
	
	$Label.text = ""
	$Label2.modulate.a = 0.0
	await get_tree().create_timer(5).timeout
	
	Connect.sendudp("-1")
	AuH._BG(AuH.ENDING_BG, 3.0, .0)
	
	await get_tree().create_timer(.2).timeout
	$Label.text = credits[0]
	await get_tree().create_timer(4.0).timeout
	$Label.text = credits[1]
	await get_tree().create_timer(2.0).timeout
	$Label.text = credits[2]
	await get_tree().create_timer(2.0).timeout
	$Label.text = ""
	await get_tree().create_timer(2.0).timeout
	
	var tween := create_tween()
	tween.tween_property($Label2, "modulate:a", 1.0, 2.0)
	tween.tween_property($Label2, "modulate:a", 0.0, 6.0).set_delay(8.0)
	
	await get_tree().create_timer(21.0).timeout
	$Label.text = credits[3]
	await get_tree().create_timer(2.0).timeout
	SceneHelper.fade_to_black(4.0, 2.0)
	
	await get_tree().create_timer(4.0).timeout
	SceneHelper.isCredit = false
	get_tree().change_scene_to_file("res://StartingScreen.tscn")
