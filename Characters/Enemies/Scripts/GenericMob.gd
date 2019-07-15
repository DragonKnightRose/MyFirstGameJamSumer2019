extends KinematicBody2D

const FACINGS = {UP = "up", DOWN = "down", LEFT = "left", RIGHT = "right"}
const SPRITE_SIZE = 16

export (float) var damage = .5
export var facing = FACINGS.DOWN


onready var sprite = $Sprite
onready var los = $LineOfSight

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
