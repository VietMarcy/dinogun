extends Control

var player = load("res://Player.tscn")
var player2 = load("res://Player2.tscn")

onready var multiplayer_config_ui = $Multiplayer_configure
onready var server_ip_address = $Multiplayer_configure/Server_ip_adress

onready var device_ip_address = $CanvasLayer/Label

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "connected_to_server")
	
	device_ip_address.text = Network.ip_address
	
func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	
	instance_player(id)
	
func _player_disconnected(id) -> void:
	print("Player " + str(id) + " has disconnected")

	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()
func _on_create_pressed():
	multiplayer_config_ui.hide()
	Network._create_server()
	
	instance_player(get_tree().get_network_unique_id())
func _on_join_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip_address.text
		Network.join_server()
		get_node(".").add_child(player)





	
func _connected_to_server() ->void:
	instance_player(get_tree().get_network_unique_id())

func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(rand_range(50,50), rand_range(0, 1)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)

