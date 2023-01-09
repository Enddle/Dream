extends Node


var IP_ADDR = "192.168.137.1"
var IP_PORT = 7000

var socketUDP = PacketPeerUDP.new()

#
#func _ready():
#	$settings_screen/ip.text = IP_ADDR
#	$settings_screen/port.text = IP_PORT as String


func _on_Button_pressed():
	$settings_screen.visible = true


func _on_save_pressed():
	IP_ADDR = $settings_screen/ip.text
	IP_PORT = $settings_screen/port.text as int
	$settings_screen.visible = false


func sendudp(msg):
	socketUDP.set_dest_address(IP_ADDR, IP_PORT)
	socketUDP.put_packet(msg.to_ascii())
