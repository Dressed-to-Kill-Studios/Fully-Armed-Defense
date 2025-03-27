extends Node
class_name WaveManagerComponent

signal intermission_started()
signal wave_changed(current_wave: int)

@export var intermission_time_seconds : float = 300

var in_intermission: bool = false
var current_wave: int = 0

var intermission_timer: Timer

func _ready() -> void:
	_create_wave_timer()
	assign_wave_manager_to_player()
	
	start_intermission()


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"): start_new_wave()


func assign_wave_manager_to_player() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	if player: player.hud.wave_manager = self


func start_new_wave() -> void:
	in_intermission = false
	current_wave += 1
	wave_changed.emit(current_wave)


func start_intermission() -> void:
	in_intermission = true
	intermission_timer.start(intermission_time_seconds)
	intermission_started.emit()
	


func _create_wave_timer() -> void:
	var timer: Timer = Timer.new()
	
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = intermission_time_seconds
	timer.timeout.connect(start_new_wave)
	
	add_child(timer)
	intermission_timer = timer
	
