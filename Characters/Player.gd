extends KinematicBody2D

const CHARACTER_NAME = "Leah"
export (int) var SPEED = 100

signal damage
signal heal
signal death
signal set_health

var velocity = Vector2()
var MAX_HEALTH = 3
var health
var defense = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	emit_signal("set_health", health)


func _physics_process(delta):
	#deal with movement
	get_movement()
	velocity = move_and_collide(velocity*delta)


func get_movement():
	var movement = Vector2()
	if(Input.is_action_pressed("move_down")):
		movement.y += 1
	if(Input.is_action_pressed("move_up")):
		movement.y -= 1
	if(Input.is_action_pressed("move_left")):
		movement.x -= 1
	if(Input.is_action_pressed("move_right")):
		movement.x += 1
		
	velocity = movement.normalized() * SPEED

