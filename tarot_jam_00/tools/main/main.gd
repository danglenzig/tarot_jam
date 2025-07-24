class_name Main
extends Node2D

@onready var main_canvas: MainCanvas = $MainCanvas
@onready var post_process: PostProcess = %PostProcess
@onready var game_environment: GameEnvironment = %GameEnvironment
@onready var intro: Intro = %Intro
@onready var act_one: ActOne = %ActOne
@onready var advert_one_phase: AdvertOnePhase = %AdvertOnePhase
@onready var act_two: ActTwo = %ActTwo
@onready var advert_two_phase: AdvertTwoPhase = %AdvertTwoPhase
@onready var act_three: ActThree = %ActThree
@onready var advert_three_phase: AdvertThreePhase = %AdvertThreePhase



signal start_game_signal
signal intro_complete
signal game_one_complete
signal advert_one_complete
signal game_two_complete
signal advert_two_complete
signal game_three_complete
signal advert_three_complete

func _ready() -> void:
	SingletonHolder.game_manager.main = self
	
	
	#main_canvas.dialogue.dialogue_choice_taken.connect(_on_rx_dialogue_choice_taken)
	
	
	start_game_signal.connect(_play_intro)
	intro_complete.connect(_play_game_one)
	game_one_complete.connect(_play_advert_one)
	advert_one_complete.connect(_play_game_two)
	game_two_complete.connect(_play_advert_two)
	advert_two_complete.connect(_play_game_three)
	game_three_complete.connect(_play_advert_three)
	advert_three_complete.connect(_play_outro)
	
	_initialize_game_phases()
	
	_show_start_menu() # start game signal emitted when player hits start

func _initialize_game_phases():
	intro.main = self
	act_one.main = self
	advert_one_phase.main = self
	act_two.main = self
	advert_two_phase.main = self
	act_three.main = self
	advert_three_phase.main = self
	

func _show_start_menu():
	main_canvas.show_layer(main_canvas.start_menu, true, true)

func _play_intro():
	intro.play()

func _play_game_one():
	act_one.play()
	
func _play_advert_one():
	advert_one_phase.play()
	
func _play_game_two():
	act_two.play()
	
func _play_advert_two():
	advert_two_phase.play()
	
func _play_game_three():
	act_three.play()
	
func _play_advert_three():
	advert_three_phase.play()
	
func _play_outro():
	print_debug("PLAY OUTRO")
	

	

	
