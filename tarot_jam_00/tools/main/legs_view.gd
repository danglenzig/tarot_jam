class_name LegsView
extends Sprite2D

#const ONE_LEG = preload("res://imported_assets/one_leg.png")
#const TWO_LEGS = preload("res://imported_assets/two_legs.png")

const ONE_ARM = preload("res://imported_assets/couch_pics/1_arm_wood.png")
const ONE_LEG = preload("res://imported_assets/couch_pics/1_foot_wood.png")
const TWO_ARMS = preload("res://imported_assets/couch_pics/2_arms_wood.png")
const TWO_LEGS = preload("res://imported_assets/couch_pics/2_feet_wood.png")

func _ready() -> void:
	visibility_changed.connect(
		func()->void:
			if not visible:
				texture = null
	)
	
func show_legs(legs: int):
	assert(legs in [1,2,3,4])
	match legs:
		1:
			texture = ONE_LEG
		2: 
			texture = TWO_LEGS
		3:
			texture = ONE_ARM
		4:
			texture = TWO_ARMS
	visible = true
