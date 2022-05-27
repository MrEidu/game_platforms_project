# Level.gd

# Background: https://www.flickr.com/photos/29638108@N06/51690240835/in/dateposted/
# Credits: Jennifer C. www.metaphoricalplatypus.com

extends Node2D

const target = preload("res://Target.tscn")
const boulder = preload("res://Boulder.tscn")

onready var targets = [] # target-ids array
onready var boulders = [] # target-ids array
var rng = RandomNumberGenerator.new()

func _ready():
	# warning-ignore:return_value_discarded
	rng.randomize()
	var my_random_number = rng.randf_range(-10.0, 10.0)
	var columnaX = rng.randf_range(0, 1.0)
	$player/arrow.connect("arrow_sound", self, "next")
	$player.global_rotation = Global.Angle # Restore last bow-angle
	var cols = Global.Cols.duplicate() # copy array
	var cols2 = Global.Cols2.duplicate() # copy array again
	randomize()
	cols.shuffle() # random order
	cols2.shuffle()
	for i in range(Global.Level): # create targets
		var obj = target.instance()
		var obj2 = boulder.instance()
		obj.id = i
		obj2.id = i
		my_random_number = rng.randf_range(-100.0, Global.Level*-Global.ScreenH)
		obj.set_position(Vector2(cols.pop_back(), Global.TargetWidth+my_random_number))
		obj2.set_position(Vector2(columnaX*Global.ScreenW, -Global.ScreenH*Global.Level*columnaX))
		targets.append(i) # contador targets
		boulders.append(i)
		obj.connect("target_signal", self, "update_targets") # target signal
		obj2.connect("target_signal", self, "update_boulders") # boulder signal
		add_child(obj)
		add_child(obj2)

func update_targets(id):
	targets.erase(id) # remove target
	if targets.empty(): # no-more targets?
		if boulders.empty():
			next() # go next-level

func update_boulders(id):
	boulders.erase(id) # remove 
	if boulders.empty(): # no-more?
		if targets.empty():
			next() # go next-level

func next(): # next-level?
	if targets.empty(): # no more targets? go next level
		if boulders.empty():
			#Global.Angle = 0 # $player.global_rotation  # store last bow-angle
			if Global.Level < Global.Cols.size(): # more levels?
				Global.Level += 1
				# warning-ignore:return_value_discarded
				get_tree().reload_current_scene() # restart
			else: # game over!
				Global.game_over()
				get_tree().quit() # close-game

