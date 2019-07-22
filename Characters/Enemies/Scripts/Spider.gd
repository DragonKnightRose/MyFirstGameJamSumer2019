extends "res://Characters/Enemies/Scripts/GenericMob.gd"

const WEB = preload("res://Projectiles/Scenes/Web.tscn")
export (int) var ATTACK_WAIT = 2
export (int) var WEB_SPEED = 5
export (int) var WEB_OFFSET = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttackTimer.wait_time = ATTACK_WAIT 
	#$AttackTimer.start()
	$MovementTimer.wait_time = MOVEMENT_WAIT
	#$MovementTimer.set_paused(true)
	print("Spider health: {0}".format([str(health)]))

func attack():
	#should not move while attacking
	moving = false
	
	#web instance
	var web = WEB.instance()
	var spawn = global_position
	var velocity #to determine path of projectile

	match facing:
		FACINGS.UP:
			spawn.y -= SPRITE_SIZE
			velocity = Vector2(0, (-1 * WEB_SPEED))
		FACINGS.DOWN:
			spawn.y += SPRITE_SIZE + WEB_OFFSET
			velocity = Vector2(0,  WEB_SPEED)
		FACINGS.LEFT:
			spawn.x -= SPRITE_SIZE
			velocity = Vector2((-1 * WEB_SPEED),0)
			web.rotatation_degrees += 90
		FACINGS.RIGHT:
			spawn.x += SPRITE_SIZE
			velocity = Vector2(WEB_SPEED,0)
			web.rotatation_degrees += 90


	web.initialize(spawn, velocity, DAMAGE)
	get_parent().add_child(web)

func hit(damage, direction = Vector2(0,0)):
	knockback(direction)
	health -= damage
	
	if health <= 0:
		queue_free()
	else:
		start_moving(facing)

func start_moving(direction):
	$AttackTimer.stop()
	$MovementTimer.start(MOVEMENT_WAIT)
	facing = direction
	moving = true
	movement_direction = Vector2(0,0)
	
	match direction:
		FACINGS.DOWN:
			movement_direction.y = 1
		FACINGS.UP:
			movement_direction.y = -1
		FACINGS.LEFT:
			movement_direction.x = -1
		FACINGS.RIGHT:
			movement_direction.x = 1

func _on_AttackTimer_timeout():
	$MovementTimer.start(MOVEMENT_WAIT)
	#$AttackTimer.start(ATTACK_WAIT)
	attack()


func _on_MovementTimer_timeout():
	$AttackTimer.start(ATTACK_WAIT)
	
	moving = true
	movement_direction = Vector2(0,0)
	
	match facing:
		FACINGS.DOWN:
			movement_direction.y = 1
		FACINGS.UP:
			movement_direction.y = -1
		FACINGS.LEFT:
			movement_direction.x = -1
		FACINGS.RIGHT:
			movement_direction.x = 1
	#print(movement_direction)

func process_movement(delta):
	#print("{0} has a velocity of {1}".format([name, velocity]))
	velocity = movement_direction.normalized() * SPEED
	
	#print("{0} has a velocity of {1}".format([name, velocity]))
	moving = velocity != Vector2(0,0)

	velocity = move_and_collide(velocity*delta)
	
	if velocity:
		#$AttackTimer.start(ATTACK_WAIT)
		$MovementTimer.start(MOVEMENT_WAIT)
		moving = false
		
		if velocity.get_collider().has_method("hit"):
			var direction = movement_direction.normalized()

			print("knockback direction from spider {0}".format([direction]))
			velocity.get_collider().hit(DAMAGE, direction)
			
		else:
			match facing:
				FACINGS.UP:
					facing = FACINGS.DOWN
				FACINGS.DOWN:
					facing = FACINGS.UP 
				FACINGS.LEFT:
					facing = FACINGS.RIGHT
				FACINGS.RIGHT:
					facing = FACINGS.LEFT
	
func _on_HitBox_body_entered(body):
	pass
