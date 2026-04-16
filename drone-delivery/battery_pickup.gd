extends Area2D

@export var amount: float = 25.0

func _on_body_entered(body):
	if body.has_method("add_battery"):
		body.add_battery(amount)
		queue_free()
