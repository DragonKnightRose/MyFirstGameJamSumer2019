extends KinematicBody2D

var DAMAGE = 0
var VELOCITY = Vector2()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(VELOCITY)
	
	#respond if there's a collision
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(DAMAGE)
		queue_free() #destroy the projectile after a collision


func initialize(position, velocity, damage = 0):
	global_position = position
	VELOCITY = velocity
	DAMAGE = damage