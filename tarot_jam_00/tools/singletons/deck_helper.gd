class_name DeckHelper
extends Node

const reverse_face_texture_path := "res://imported_assets/cards/Card png/reverse_01.png"

const face_up_data := {
	0: {
		"name": "The Fool",
		"texture_path": "res://imported_assets/cards/Card png/The Fool.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/1.png",
	},
	1: {
		"name": "The Magician",
		"texture_path": "res://imported_assets/cards/Card png/The Magician.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/2.png",
	},
	2: {
		"name": "The High Priestess",
		"texture_path": "res://imported_assets/cards/Card png/The High Priestess.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/3.png",
	},
	3: {
		"name": "The Empress",
		"texture_path": "res://imported_assets/cards/Card png/The Empress.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/4.png",
	},
	4: {
		"name": "The Emperor",
		"texture_path": "res://imported_assets/cards/Card png/The Emperor.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/5.png",
	},
	5: {
		"name": "The Hierophant",
		"texture_path": "res://imported_assets/cards/Card png/The Hierophant.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/6.png",
	},
	6: {
		"name": "The Lovers",
		"texture_path": "res://imported_assets/cards/Card png/The Lovers.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/7.png",
	},
	7: {
		"name": "The Chariot",
		"texture_path": "res://imported_assets/cards/Card png/The Chariot.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/8.png",
	},
	8: {
		"name": "Strength",
		"texture_path": "res://imported_assets/cards/Card png/Strength.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/9.png",
	},
	9: {
		"name": "The Hermit",
		"texture_path": "res://imported_assets/cards/Card png/The Hermit.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/10.png",
	},
	10: {
		"name": "Wheel of Fortune",
		"texture_path": "res://imported_assets/cards/Card png/Wheel of fortune.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/11.png",
	},
	11: {
		"name": "Justice",
		"texture_path": "res://imported_assets/cards/Card png/Justice.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/12.png",
	},
	12: {
		"name": "The Hanged Man",
		"texture_path": "res://imported_assets/cards/Card png/The Hanged Man.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/13.png",
	},
	13: {
		"name": "Death",
		"texture_path": "res://imported_assets/cards/Card png/Death.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/14.png",
	},
	14: {
		"name": "Temperance",
		"texture_path": "res://imported_assets/cards/Card png/Temperance.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/15.png",
	},
	15: {
		"name": "The Devil",
		"texture_path": "res://imported_assets/cards/Card png/The Devil.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/16.png",
	},
	16: {
		"name": "The Tower",
		"texture_path": "res://imported_assets/cards/Card png/The Tower.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/17.png",
	},
	17: {
		"name": "The Star",
		"texture_path": "res://imported_assets/cards/Card png/The Star.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/18.png",
	},
	18: {
		"name": "The Moon",
		"texture_path": "res://imported_assets/cards/Card png/The Moon.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/19.png",
	},
	19: {
		"name": "The Sun",
		"texture_path": "res://imported_assets/cards/Card png/The Sun.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/20.png",
	},
	20: {
		"name": "Judgement",
		"texture_path": "res://imported_assets/cards/Card png/Judgement.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/21.png",
	},
	21: {
		"name": "The World",
		"texture_path": "res://imported_assets/cards/Card png/The World.png",
		"standard_face_texture_path": "res://imported_assets/cards/standard/updated/22.png",
	},
}
