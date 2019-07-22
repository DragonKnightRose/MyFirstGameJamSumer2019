extends TextureRect

const values = {EMPTY = 0, HALF = .5, FULL = 1}
var VALUE

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true

func set_value(value):
	VALUE = value
	match value:
		values.EMPTY:
			texture = preload("res://Assets/GUI/Hearts/Heart_Empty.png")
			print("empty sprite")
		values.HALF:
			texture = preload("res://Assets/GUI/Hearts/Heart_Half.png")
			print("half sprite")
		values.FULL:
			texture = preload("res://Assets/GUI/Hearts/Heart_Full.png")
			print("full sprite")
		_:
			#default to an empty sprite
			texture = preload("res://Assets/GUI/Hearts/Heart_Empty.png")
			print("default empty")

func decrease_value():
	match VALUE:
		values.EMPTY:
			print("can't decrease!")
		values.HALF:
			preload("res://Assets/GUI/Hearts/Heart_Empty.png")
			VALUE = values.EMPTY
		values.FULL:
			texture = preload("res://Assets/GUI/Hearts/Heart_Half.png")
			VALUE = values.HALF