extends Character

const SPRITE_SIZE = 16

export (float) var DAMAGE = .5
export (int) var MOVEMENT_WAIT = 1

onready var sprite = $Sprite
onready var los = $LineOfSight

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if moving and !is_stunned:
		animation_switcher("walk_")
		process_movement(delta)
	else:
		animation_switcher("idle_")
		
	process_animation()

func _on_StunTimer_timeout():
	is_stunned = false
