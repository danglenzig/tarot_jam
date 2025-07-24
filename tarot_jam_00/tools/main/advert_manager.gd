class_name AdvertManager
extends Node2D

enum Adverts {ADVERT_ONE, ADVERT_TWO, ADVERT_THREE}

var game_env: GameEnvironment = null:
	set(new_value):
		game_env = new_value
		if game_env:
			game_env_ready.emit()
			
			
signal game_env_ready
signal advert_complete

const advert_paths := {
	"advert_one": "res://game/main/adverts/advert_one.tscn",
	"advert_two": "res://game/main/adverts/advert_two.tscn",
	"advert_three": "res://game/main/adverts/advert_three.tscn",
}

func _ready() -> void:
	await game_env_ready
	
func start_advert(advert_id: int):
	assert(advert_id in [0,1,2])
	game_env.game_mode = game_env.GameMode.ADVERT
	
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm._play_main_music(false)
	
	await clear_adverts()
	await _adjust_camera("in")
	
	match advert_id:
		0: # ADVERT_ONE
			_load_advert("advert_one")
		1: # ADVERT_TWO
			_load_advert("advert_two")
		2: # ADVERT_THREE
			_load_advert("advert_three")

func _load_advert(advert_string: String):
	assert(advert_string in advert_paths.keys())
	
	var advert_scene: PackedScene
	var advert_node: Advert
	
	match advert_string:
		"advert_one":
			advert_scene = load(advert_paths["advert_one"])
		"advert_two":
			advert_scene = load(advert_paths["advert_two"])
		"advert_three":
			advert_scene = load(advert_paths["advert_three"])
			
	advert_node = advert_scene.instantiate()
	call_deferred("add_child", advert_node)
	await advert_node.tree_entered
	
	#advert_node.play_video()
	
	await advert_node.advert_finished
	
	_on_advert_complete(advert_string)

func clear_adverts()->bool:
	for child in get_children():
		child.call_deferred("queue_free")
		await child.tree_exited
	return true
	
func _adjust_camera(direction: String)->bool:
	assert(direction in ["in","out"])
	var cammy: GameCamera = game_env.game_camera
	if direction == "in":
		cammy.zoom_in()
		await cammy.zoom_in_complete
		return true
	if direction == "out":
		cammy.zoom_out()
		await cammy.zoom_out_complete
		return true
	return true
	
func _on_advert_complete(advert_string):
	#var main: Main = SingletonHolder.game_manager.main
	#match advert_string:
	#	"advert_one":
	#		main.advert_one_complete.emit()
	#	"advert_two":
	#		main.advert_two_complete.emit()
	#	"advert_three":
	#		main.advert_three_complete.emit()
	
	await clear_adverts()
	await _adjust_camera("out")
	game_env.game_mode = game_env.GameMode.NONE
	advert_complete.emit()
	
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm._play_main_music(true)
