extends Area2D

var spellType : int
const SPEED = 10
var accel = 10
var direction : Vector2
@onready var duration: Timer = $Duration

func _ready():
	duration.start()
	spellType = 1

func _physics_process(delta):
	position += direction * SPEED * delta * accel
	accel *= 1.1

func set_firebolt(startPosition, targetPosition):
	position = startPosition
	direction = (targetPosition - startPosition).normalized()
	rotation = position.angle_to_point(targetPosition)

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if !body.is_in_group("player"):
		if body.is_in_group("mobs"):
			body.take_damage(5)
			queue_free()
		queue_free()


func _on_duration_timeout() -> void:
	queue_free()
