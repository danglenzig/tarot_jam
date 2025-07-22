class_name DeckHelper
extends Node

const reverse_face_texture_path := "res://imported_assets/cards/Card png/reverse.png"

const face_up_data := {
	0: {
		"name": "The Fool",
		"texture_path": "res://imported_assets/cards/Card png/The Fool.png"
	},
	1: {
		"name": "The Magician",
		"texture_path": "res://imported_assets/cards/Card png/The Magician.png"
	},
	2: {
		"name": "The High Priestess",
		"texture_path": "res://imported_assets/cards/Card png/The High Priestess.png"
	},
	3: {
		"name": "The Empress",
		"texture_path": "res://imported_assets/cards/Card png/The Empress.png"
	},
	4: {
		"name": "The Emperor",
		"texture_path": "res://imported_assets/cards/Card png/The Emperor.png"
	},
	5: {
		"name": "The Hierophant",
		"texture_path": "res://imported_assets/cards/Card png/The Hierophant.png"
	},
	6: {
		"name": "The Lovers",
		"texture_path": "res://imported_assets/cards/Card png/The Lovers.png"
	},
	7: {
		"name": "The Chariot",
		"texture_path": "res://imported_assets/cards/Card png/The Chariot.png"
	},
	8: {
		"name": "Strength",
		"texture_path": "res://imported_assets/cards/Card png/Strength.png"
	},
	9: {
		"name": "The Hermit",
		"texture_path": "res://imported_assets/cards/Card png/The Hermit.png"
	},
	10: {
		"name": "Wheel of Fortune",
		"texture_path": "res://imported_assets/cards/Card png/Wheel of fortune.png"
	},
	11: {
		"name": "Justice",
		"texture_path": "res://imported_assets/cards/Card png/Justice.png"
	},
	12: {
		"name": "The Hanged Man",
		"texture_path": "res://imported_assets/cards/Card png/The Hanged Man.png"
	},
	13: {
		"name": "Death",
		"texture_path": "res://imported_assets/cards/Card png/Death.png"
	},
	14: {
		"name": "Temperance",
		"texture_path": "res://imported_assets/cards/Card png/Temperance.png"
	},
	15: {
		"name": "The Devil",
		"texture_path": "res://imported_assets/cards/Card png/The Devil.png"
	},
	16: {
		"name": "The Tower",
		"texture_path": "res://imported_assets/cards/Card png/The Tower.png"
	},
	17: {
		"name": "The Star",
		"texture_path": "res://imported_assets/cards/Card png/The Star.png"
	},
	18: {
		"name": "The Moon",
		"texture_path": "res://imported_assets/cards/Card png/The Moon.png"
	},
	19: {
		"name": "The Sun",
		"texture_path": "res://imported_assets/cards/Card png/The Sun.png"
	},
	20: {
		"name": "Judgement",
		"texture_path": "res://imported_assets/cards/Card png/Judgement.png"
	},
	21: {
		"name": "The World",
		"texture_path": "res://imported_assets/cards/Card png/The World.png"
	},
}
