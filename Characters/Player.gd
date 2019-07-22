extends Character

const CHARACTER_NAME = "Leah"
const SWORD = preload("res://Items/Sword.tscn")


export (int) var ACTION_DISTANCE = 16
export (int) var ACTION_OFFSET = 8
export (int) var SPRITE_SIZE = 2

signal set_health
signal set_max_health

onready var action_ray = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$StunTimer.wait_time = STUN_TIME
	emit_signal("set_max_health", health)
	emit_signal("set_health", health)


func _physics_process(delta):
	#deal with movement
	get_movement()
	
	
	#deal with actions
	get_action()
	
	#move
	process_movement(delta)
	
	#deal with animations
	if moving:
		animation_switcher("walk_")
	else:
		animation_switcher("idle_")
		
	process_animation()

func hit(damage, direction = Vector2(0,0)):
	
	health -= damage
	if health <= 0:
		print("player died!")
		emit_signal("death")
	else:
		print("{0} health remaining".format([str(health)]))
		emit_signal("set_health",health)
	
	
	if direction == Vector2.ZERO:
		print("direction is default")
		print("movement direction {0}".format([movement_direction]))
		direction = movement_direction
		#reverse the movement direction
		direction.x *= -1
		direction.y *= -1
		print("computed knockback velocity: {0}".format([direction]))
	
		
	knockback(direction)
		
func get_movement():
	movement_direction = Vector2(0,0)
	if is_stunned:
		return
	
	if(Input.is_action_pressed("move_down")):
		movement_direction.y += 1
		facing = FACINGS.DOWN
	if(Input.is_action_pressed("move_up")):
		movement_direction.y -= 1
		facing = FACINGS.UP
	if(Input.is_action_pressed("move_left")):
		movement_direction.x -= 1
		facing = FACINGS.LEFT
	if(Input.is_action_pressed("move_right")):
		movement_direction.x += 1
		facing = FACINGS.RIGHT
		
	var cast_to = Vector2(0,0)
	match facing:
		FACINGS.DOWN:
			cast_to.y = 1 * ACTION_DISTANCE
		FACINGS.UP:
			cast_to.y = -1 * (ACTION_DISTANCE + ACTION_OFFSET)
		FACINGS.LEFT:
			cast_to.x = -1 * ACTION_DISTANCE
		FACINGS.RIGHT:
			cast_to.x = 1 * ACTION_DISTANCE
	
	action_ray.cast_to = cast_to
		

	
		
func get_action():
	if Input.is_action_just_pressed("action_primary"):
		var collider = action_ray.get_collider()
		if collider:
			print("interacting")
			if collider.has_method("interact"):
				collider.interact()
		else:
			attack(SWORD)

func attack(weapon):
	print("attack with sword")
	var sword = SWORD.instance()
	sword.add_to_group("player_sword")
	
	if get_tree().get_nodes_in_group("player_sword").size() > 1:
		sword.queue_free()
	else:
		var spawn = global_position
		
		match facing:
			FACINGS.UP:
				spawn.y -= SPRITE_SIZE
			FACINGS.DOWN:
				spawn.y += SPRITE_SIZE
			FACINGS.LEFT:
				spawn.x -= SPRITE_SIZE
			FACINGS.RIGHT:
				spawn.x += SPRITE_SIZE
		#sword.initialize(spawn)
		
		add_child(sword)
		sword.play_animation(facing)

func process_movement(delta):
	#print("{0} has a velocity of {1}".format([name, velocity]))
	velocity = movement_direction.normalized() * SPEED
	
	#print("{0} has a velocity of {1}".format([name, velocity]))
	moving = velocity != Vector2(0,0)
	
	velocity = move_and_collide(velocity*delta)
	if velocity and "DAMAGE" in velocity.get_collider():
		hit(velocity.get_collider().DAMAGE)


func _on_StunTimer_timeout():
	is_stunned = false
