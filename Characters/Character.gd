class_name Character

extends KinematicBody2D

const FACINGS = {DOWN = "down", UP = "up", LEFT = "left", RIGHT = "right"}
const GRID_SIZE = 16

export (int) var SPEED = 100
export var facing = FACINGS.DOWN
export var STUN_TIME = .75

onready var player = $AnimationPlayer

signal damaged
signal heal
signal death

var MAX_HEALTH = 3
var health
var defense = 0

var movement_direction = Vector2()
var velocity = Vector2()
var moving = false
var animation = ""

var is_stunned = false

func _ready():
	health = MAX_HEALTH
	
func knockback(direction):
	#don't do anything if already stunned
	if is_stunned:
		return
		
	velocity = direction.normalized() * GRID_SIZE
	velocity = move_and_collide(velocity)
	
	if has_node("StunTimer"):
		is_stunned = true
		if $StunTimer.time_left == 0:
			$StunTimer.start(STUN_TIME)
func animation_switcher(action):
	var target_animation = str(action,facing)
	if player.has_animation(target_animation):
		animation = target_animation
	
func process_animation():
	if player.current_animation != animation and player.has_animation(animation):
		player.play(animation)
		
func process_movement(delta):
	#print("{0} has a velocity of {1}".format([name, velocity]))
	velocity = movement_direction.normalized() * SPEED
	
	#print("{0} has a velocity of {1}".format([name, velocity]))
	moving = velocity != Vector2(0,0)
	
	velocity = move_and_collide(velocity*delta)
