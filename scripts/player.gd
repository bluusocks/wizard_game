extends CharacterBody2D

signal xp_changed(xp : int)

#Player Speed
const SPEED = 300.0

var xp = 0
@onready var xp_display: Label = $"../HUD/xpDisplay"

#Spell variables
var targetPosition : Vector2
var aimDir : Vector2
var preloadFirebolt = preload("res://scenes/firebolt.tscn")
var numSelected = 0
var spellSlots = [0,0,0,0]
var selectedSpell = [false,false,false,false]

@onready var cast_cd: Timer = $CastCD
var canCast = true

func _input(event):
	#process mouse input
	if event is InputEventMouseButton:
		if event.is_action("LMB") and canCast:
			cast()
	
	#process keyboard input
	if event is InputEventKey and event.is_pressed() and not event.echo:
		var index = event.keycode - KEY_1

		if selectedSpell.count(true) >= 2:
				selectedSpell.fill(false)

		if index >= 0 and index < selectedSpell.size():
			selectedSpell[index] = !selectedSpell[index]
			print(selectedSpell)

#Movement
func _physics_process(_delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * SPEED
	
	checkCollision()
	move_and_slide()
	
#Casting Firebolt, update later
func cast():
	canCast = false
	cast_cd.start()
	targetPosition = get_global_mouse_position()
	aimDir = (targetPosition - global_position).normalized()
	var firebolt = preloadFirebolt.instantiate()
	firebolt.set_firebolt(position, targetPosition)
	get_parent().add_child(firebolt)

func checkCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider():
			var collider = collision.get_collider()
			if collider.is_in_group("mobs"):
				die()

func die():
	print("you died!")
	if get_tree():
		get_tree().reload_current_scene()

func gainXP(amount):
	xp += amount
	emit_signal("xp_changed", xp)

func _on_cast_cd_timeout() -> void:
	canCast = true
