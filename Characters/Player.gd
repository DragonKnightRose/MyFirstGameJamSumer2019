extends KinematicBody2D

const CHARACTER_NAME = "Leah"
const FACINGS = {DOWN = "down", UP = "up", LEFT = "left", RIGHT = "right"}

export (int) var SPEED = 100
export (int) var ACTION_DISTANCE = 10
export var facing = FACINGS.DOWN

signal damaged
signal heal
signal death
signal set_health
signal set_max_health

onready var player = $AnimationPlayer
onready var action_ray = $RayCast2D

var velocity = Vector2()
var moving = false
var animation = ""

var MAX_HEALTH = 3
var health
var defense = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	emit_signal("set_max_health", health)
	emit_signal("set_health", health)


func _physics_process(delta):
	#deal with movement
	get_movement()
	velocity = move_and_collide(velocity*delta)
	
	#deal with actions
	get_action()
	
	#deal with animations
	process_animation()

func hit(damage):
	print("Player hit for {0} damage!".format([str(damage)]))
	health -= damage
	if health <= 0:
		print("player died!")
		emit_signal("death")
	else:
		print("{0} health remaining".format([str(health)]))
		emit_signal("set_health",health)

func get_movement():
	var movement = Vector2()
	if(Input.is_action_pressed("move_down")):
		movement.y += 1
		facing = FACINGS.DOWN
		
		animation = "walk_down"
	if(Input.is_action_pressed("move_up")):
		movement.y -= 1
		facing = FACINGS.UP
		
		animation = "walk_up"
	if(Input.is_action_pressed("move_left")):
		movement.x -= 1
		facing = FACINGS.LEFT
		
		animation = "walk_left"
	if(Input.is_action_pressed("move_right")):
		movement.x += 1
		facing = FACINGS.RIGHT
		
		animation = "walk_right"
	velocity = movement.normalized() * SPEED
	
	moving = velocity != Vector2(0,0)
	
	var cast_to = Vector2(0,0)
	match facing:
		FACINGS.DOWN:
			cast_to.y = 1 * ACTION_DISTANCE
		FACINGS.UP:
			cast_to.y = -1 * ACTION_DISTANCE
		FACINGS.LEFT:
			cast_to.x = -1 * ACTION_DISTANCE
		FACINGS.RIGHT:
			cast_to.x = 1 * ACTION_DISTANCE
	
	action_ray.cast_to = cast_to

func process_animation():
	if player.is_playing():
		if !moving || player.current_animation != animation:
			player.stop()
	
	if moving:
		if !player.is_playing():
			if player.has_animation(animation):
				player.play(animation)
		
func get_action():
	if Input.is_action_just_pressed("action_primary"):
		print("interacting")
		var collider = action_ray.get_collider()
		if collider:
			if collider.has_method("interact"):
				collider.interact()
