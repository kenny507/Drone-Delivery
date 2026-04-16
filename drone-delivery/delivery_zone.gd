extends Area2D

func _on_body_entered(body):
	print("Entered delivery zone:", body.name)
	if body.name == "Player" and body.has_package:
		body.deliver_package()
