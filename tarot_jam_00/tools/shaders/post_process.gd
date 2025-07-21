class_name PostProcess
extends Control

@onready var _post_process_rect: ColorRect = %PostProcessRect
var _shader_mat: ShaderMaterial = null

## Master
var enabled := true:
	set(new_value):
		enabled = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("shader_enabled", enabled)

## Saturation
var saturation_enabled := true:
	set(new_value):
		saturation_enabled = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("saturation_enabled", saturation_enabled)
var saturation_amount := 1.0:
	set(new_value):
		saturation_amount = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("saturation_amount", saturation_amount)
var saturation_monochrome_color := Color(0.145,0.145,0.145):
	set(new_value):
		saturation_monochrome_color = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("monochrome_color", saturation_monochrome_color)

## Sharpness
var sharpness_enabled := true:
	set(new_value):
		sharpness_enabled = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("sharpness_enabled", sharpness_enabled)
var sharpness_size := 1.0:
	set(new_value):
		sharpness_size = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("sharpness_size", sharpness_size)
var sharpness_intensity := 1.0:
	set(new_value):
		sharpness_intensity = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("sharpness_intensity", sharpness_intensity)

## Brightness
var brightness_enabled := true:
	set(new_value):
		brightness_enabled = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("brightness_enabled", brightness_enabled)
var brightness_amount := 0.0:
	set(new_value):
		brightness_amount = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("brightness_amount", brightness_amount)

## Warmth
var warmth_enabled := true:
	set(new_value):
		warmth_enabled = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("warmth_enabled", warmth_enabled)
var warmth_amount := 0.0:
	set(new_value):
		warmth_amount = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("warmth_amount", warmth_amount)

## Contrast
var contrast_enabled := true:
	set(new_value):
		contrast_enabled = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("contrast_enabled", contrast_enabled)
var contrast_amount := 0.0:
	set(new_value):
		contrast_amount = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("contrast_amount", contrast_amount)

## Chromatic aberration
var chromatic_aberration_enabled := true:
	set(new_value):
		chromatic_aberration_enabled = new_value
		_shader_mat.set_shader_parameter("chromatic_abberation_enabled", chromatic_aberration_enabled)
var chromatic_aberration_seperation := 0.016:
	set(new_value):
		chromatic_aberration_seperation = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("chromatic_abberation_seperation", chromatic_aberration_seperation)
var chromatic_aberration_intensity := 1.5:
	set(new_value):
		chromatic_aberration_intensity = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("chromatic_abberation_intensity", chromatic_aberration_intensity)
var chromatic_aberration_blur_strength := 1.0:
	set(new_value):
		chromatic_aberration_blur_strength = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("chromatic_abberation_blur_strength", chromatic_aberration_blur_strength)

const SATURATION_AMOUNT 					= 1.0
const SATURATION_MONOCHROME_COLOR 			= Color(
	0.145, 0.145, 0.145
)
const SHARPNESS_SIZE 						= 1.0
const SHARPNESS_INTENSITY 					= 1.0
const BRIGHTNESS_AMOUNT 					= 0.0
const WARMTH_AMOUNT 						= 0.0
const CONTRAST_AMOUNT 						= 0.0
const CHROMATIC_ABERRATION_SEPERATION 		= 0.016
const CHROMATIC_ABERRATION_INTENSITY 		= 1.5
const CHROMATIC_ABERRATION_BLUR_STRENGTH 	= 1.0

func _ready() -> void:
	_shader_mat = _post_process_rect.material as ShaderMaterial
	
	saturation_amount 					= SATURATION_AMOUNT
	saturation_monochrome_color 		= SATURATION_MONOCHROME_COLOR
	sharpness_size 						= SHARPNESS_SIZE
	sharpness_intensity 				= SHARPNESS_INTENSITY
	brightness_amount 					= BRIGHTNESS_AMOUNT
	warmth_amount 						= WARMTH_AMOUNT
	contrast_amount 					= CONTRAST_AMOUNT
	chromatic_aberration_seperation 	= CHROMATIC_ABERRATION_SEPERATION
	chromatic_aberration_intensity 		= CHROMATIC_ABERRATION_INTENSITY
	chromatic_aberration_blur_strength 	= CHROMATIC_ABERRATION_BLUR_STRENGTH
