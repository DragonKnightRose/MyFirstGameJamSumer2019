extends Node2D

# Declare member variables here. Examples:
var cells
var cell_size
onready var base_layer = get_node("Ground")

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize():
	#base everything off the ground layer
	var ground = base_layer

	#determine cell size
	cell_size = ground.cell_size
	print("Map cell size is: " + str(cell_size))

	#count the cells in each direction
	var index = Vector2(0,0)
	cells = Vector2(0,0)
	var invalid = ground.INVALID_CELL

	#loop through the x's
	while ground.get_cellv(index) != invalid:
		cells.x += 1
		index.x += 1

	##loop through the y's
	index.x = 0
	while ground.get_cellv(index) != invalid:
		cells.y += 1
		index.y += 1


	print(cells)