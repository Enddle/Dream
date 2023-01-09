extends Control


var tween
var isMobile
var scene_out = false


func _ready():
	Connect.sendudp("0")
	Connect.resetbang()
	
	isMobile = (OS.get_name() == "iOS")
	
	SceneHelper.rounds = 0
	SceneHelper.isStarting = true
	SceneHelper.scene_out = false
	
	AuH._BG(AuH.LOOP_BG, -6.0, 5.0)


func _process(delta):
	if scene_out:
		return
	
	if !isMobile:
		return
	
	var g = Input.get_gyroscope() * delta
	if stepify(g.length(), 0.1) != 0:
		scene_out = true
		start_tutorial()


func start_tutorial():
	SceneHelper.fade_to_black(1, 1)
	yield(get_tree().create_timer(1), "timeout")
	SceneHelper.isStarting = false
	get_tree().change_scene("res://Tutorial.tscn")


func _on_Button_button_down():
	$Label2.text = AudioServer.device
	$Label2.text += "\n\n"
	for d in AudioServer.get_device_list():
		$Label2.text += d
		$Label2.text += "\n"
	pass # Replace with function body.


func _on_settings_pressed():
	SceneHelper.settings_open()

