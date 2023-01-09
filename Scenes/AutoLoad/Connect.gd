extends Node


var IP_ADDR = "192.168.137.1"
var IP_PORT = 7000

var socketUDP = PacketPeerUDP.new()

func sendudp(msg):
	socketUDP.set_dest_address(IP_ADDR, IP_PORT)
	socketUDP.put_packet(msg.to_ascii())
