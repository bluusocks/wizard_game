extends Node

@onready var player: CharacterBody2D = $Player
@onready var spawn_location: PathFollow2D = $SpawnPath/SpawnLocation
@onready var xp_display: Label = $HUD/xpDisplay

var preloadSlime = preload("res://scenes/slime.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var slime = preloadSlime.instantiate()
	spawn_location.progress_ratio = randf()
	slime.set_position(player.global_position + spawn_location.position)
	add_child(slime)

func _on_player_xp_changed(xp: int) -> void:
	xp_display.text = "XP: %d" % xp
