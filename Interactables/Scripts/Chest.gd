extends StaticBody2D

enum STATES {OPEN, CLOSED}

var state = STATES.CLOSED
var contents = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite_Closed.visible = true
	$Sprite_Open.visible = false

func interact():
	print("chest interacted!")

func add_item(item):
	contents.append(item)

func remove_item(from_front = true):
	if from_front:
		return contents.pop_front()
	else:
		return contents.pop_back()

func get_item(from_front = true):
	if from_front:
		return contents.front()
	else:
		return contents.back()

func get_contents():
	return contents.duplicate()