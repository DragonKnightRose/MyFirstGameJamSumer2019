extends Area2D

export (float) var DAMAGE = 1

onready var player = $AnimationPlayer

var knockback_direction = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(position, damage = DAMAGE):
	global_position = position
	DAMAGE = damage

func play_animation(facing, action = "slash_"):
	var animation = str(action, facing)
	
	match facing:
		"up":
			knockback_direction = Vector2.UP
		"down":
			knockback_direction = Vector2.DOWN
		"left":
			knockback_direction = Vector2.LEFT
		"right":
			knockback_direction = Vector2.RIGHT
	
	if player.has_animation(animation):
		player.play(animation)
	else:
		queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_Sword_body_entered(body):
	if body.has_method("hit"):
		print("hit {0} with sword!".format([body.name]))
		body.hit(DAMAGE, knockback_direction)
	
