extends RigidBody2D

@onready var player: CharacterBody2D = $"../Player"
var preloadXP = preload("res://scenes/xp_bubble.tscn")

const BASE_SPEED = 2
var speed = 2
var hp = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func take_damage(d):
	hp -= d
	print("slime took ", d, " damage!")
	if hp > 0:
		#shitty way to take knockback. fix later
		speed = -10
		await get_tree().create_timer(0.1).timeout
		speed = BASE_SPEED
	if hp <= 0:
		var xp = preloadXP.instantiate()
		xp.position = position
		get_parent().add_child(xp)
		queue_free()

func _physics_process(_delta):
	var dir = (player.global_position - global_position).normalized()
	var velocity = dir * speed
	move_and_collide(velocity)
