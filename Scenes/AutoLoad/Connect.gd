extends Node


var IP_ADDR = "192.168.0.47"
var IP_PORT_0 = 7001
var IP_PORT_1 = 7002
var IP_PORT_2 = 7003

var bang = 0

var socketUDP = PacketPeerUDP.new()

func update(ip, port):
	IP_ADDR = ip
	IP_PORT_0 = port as int
	IP_PORT_1 = IP_PORT_0 + 1
	IP_PORT_2 = IP_PORT_0 + 2

func sendudp(msg):
	socketUDP.set_dest_address(IP_ADDR, IP_PORT_0)
	socketUDP.put_packet(msg.to_ascii())

func sendextra(val):
	socketUDP.set_dest_address(IP_ADDR, IP_PORT_1)
	socketUDP.put_packet((val as String).to_ascii())

func resetbang():
	bang = 0
	socketUDP.set_dest_address(IP_ADDR, IP_PORT_2)
	socketUDP.put_packet((bang as String).to_ascii())

func sendbang():
	bang += 1
	socketUDP.set_dest_address(IP_ADDR, IP_PORT_2)
	socketUDP.put_packet((bang as String).to_ascii())
