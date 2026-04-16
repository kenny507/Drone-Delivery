extends Area2D

var picked_up = false

func _on_body_entered(body):
	print("Touched package:", body.name)
	if picked_up:
		return
	if body.has_method("pick_up_package"):
		picked_up = true
		body.pick_up_package()
		queue_free()
