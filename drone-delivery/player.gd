extends CharacterBody2D

@export var speed: float = 200.0
@export var max_battery: float = 100.0
@export var drain_rate: float = 10.0
@onready var status_label = $"../UI/StatusLabel"
var battery: float = 0.0
var has_package = false
var is_dead = false
@export var boost_speed: float = 350.0
@export var boost_drain_rate: float = 25.0

@onready var bar = $"../UI/BatteryBar"
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	battery = max_battery
	animated_sprite.play("idle")

func _physics_process(delta):
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	var current_speed = speed
	var drain = drain_rate

	# BOOST
	if Input.is_action_pressed("boost") and battery > 0:
		current_speed = boost_speed
		drain = boost_drain_rate

	if direction != Vector2.ZERO:
		battery -= drain * delta

	battery = clamp(battery, 0.0, max_battery)

	if battery <= 0.0:
		is_dead = true
		print("Battery dead")
		status_label.text = "Battery dead, better luck next time! Press 'R' to Restart"
		return

	velocity = direction.normalized() * current_speed
	move_and_slide()

	# Animation
	if direction != Vector2.ZERO:
		animated_sprite.play("fly")
	else:
		animated_sprite.play("idle")

func _process(delta):
	if bar != null:
		bar.max_value = max_battery
		bar.value = battery
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

func add_battery(amount: float):
	battery += amount
	battery = clamp(battery, 0.0, max_battery)

func pick_up_package():
	has_package = true
	print("Package picked up")
	status_label.text = "Deliver the package"
	
func deliver_package():
	if has_package:
		has_package = false
		print("DELIVERED! YOU WIN")
		status_label.text = "Delivery complete! You Win! Press 'R' to play again."
