extends CanvasLayer

var MAX_HEARTS = 0
var HEART = preload("res://Menus/Heart.tscn")

onready var heart_bar = $MarginContainer/VBoxContainer/top_line/hearts

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_Player_set_max_health(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_heart():
	print("Adding heart...")
	var heart = HEART.instance()
	heart.set_value(1)
	heart_bar.add_child(heart)
	MAX_HEARTS += 1
	
func remove_heart():
	print("Removing heart")
	var heart = heart_bar.get_children()[0]
	heart.queue_free()
	
func set_health(health):
	var full_hearts = floor(health)
	var partial_heart = (health - full_hearts > 0)
	
	var hearts = heart_bar.get_children()
	
	#number of empty hearts is the maximum number minus the still full number
	for i in range(MAX_HEARTS-1, full_hearts-1, -1):
		hearts[i].set_value(0)
		
	#set the partial heart if needed
	if partial_heart:
		hearts[full_hearts].set_value(.5)

func _on_Player_damaged(damage):
	pass 


func _on_Player_set_max_health(health):
	print("setting GUI max hearts...")
	var current_hearts = heart_bar.get_child_count()
	
	print("Target Hearts:{0} Current Hearts:{1}".format([str(health),str(current_hearts)]))
	
	if current_hearts < health:
		#need to add hearts
		for i in range(health - current_hearts):
			add_heart()
	if current_hearts > health:
		for i in range(current_hearts - health):
			remove_heart()
			
	
	MAX_HEARTS = health


func _on_Player_set_health(health):
	set_health(health)

func _on_Player_death():
	set_health(0)
