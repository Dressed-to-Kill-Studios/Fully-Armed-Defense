extends Node
class_name WaveManagerComponent

signal wave_changed(current_wave: int)

var player: Player

var in_intermission: bool = false
var current_wave: int = 0


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player: wave_changed.connect(player.hud.update_wave_label)


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"): start_new_wave()


func start_new_wave() -> void:
	current_wave += 1
	wave_changed.emit(current_wave)
