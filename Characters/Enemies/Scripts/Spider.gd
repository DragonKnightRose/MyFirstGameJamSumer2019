extends "res://Characters/Enemies/Scripts/GenericMob.gd"

const WEB = preload("res://Projectiles/Scenes/Web.tscn")
export (int) var web_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack():
	var web = WEB.instance()
	var spawn = global_position
	var velocity #to determine path of projectile

	match facing:
		FACINGS.UP:
			spawn.y -= SPRITE_SIZE
			velocity = Vector2(0, (-1 * web_speed))
		FACINGS.DOWN:
			spawn.y += SPRITE_SIZE
			velocity = Vector2(0,  web_speed)
		FACINGS.LEFT:
			spawn.x -= SPRITE_SIZE
			velocity = Vector2((-1 * web_speed),0)
			web.rotatation_degrees += 90
		FACINGS.RIGHT:
			spawn.x += SPRITE_SIZE
			velocity = Vector2(web_speed,0)
			web.rotatation_degrees += 90


	web.initialize(spawn, Vector2(0, web_speed), damage)
	get_parent().add_child(web)
