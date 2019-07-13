extends KinematicBody2D

const WEB = preload("res://Projectiles/Web.tscn")
const FACINGS = {UP = "up", DOWN = "down", LEFT = "left", RIGHT = "right"}
const SPRITE_SIZE = 16

export (float) var damage = .5
export (int) var web_speed = 5
export var facing = FACINGS.DOWN


onready var sprite = $Sprite
onready var los = $LineOfSight

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
	
func look_down():
	los.rotation_degrees = 0
	sprite.rotation_degrees = los.rotation_degrees
	facing = FACINGS.DOWN

func look_up():
	los.rotation_degrees = 180
	sprite.rotation_degrees = los.rotation_degrees
	facing = FACINGS.UP
	
func look_left():
	los.rotation_degrees = 90
	sprite.rotation_degrees = los.rotation_degrees
	facing = FACINGS.LEFT
	
func look_right():
	los.rotation_degrees = 270
	sprite.rotation_degrees = los.rotation_degrees
	facing = FACINGS.RIGHT
