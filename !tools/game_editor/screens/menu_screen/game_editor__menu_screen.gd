class_name GameEditor__MenuScreen
extends CanvasLayer

@onready var _open_dialog: FileDialog = $OpenDialog
@onready var _create_dialog: FileDialog = $CreateDialog
@onready var _generate_chess_dialog: FileDialog = $GenerateChessDialog
@onready var _chess_squere_size: TextEdit = %ChessSquereSize
@onready var _chess_map_width: TextEdit = %ChessMapWidth
@onready var _chess_map_height: TextEdit = %ChessMapHeight
@onready var _chess_big_optim: CheckBox = %BigSizeOptimisations
@onready var _chess_progress: Label = %ChessMapProgress

@onready var _game_editor_state: GameEditorState = Injector.inject(GameEditorState, self)

var _db: GameDb
var _biome_repository: BiomeRepository
var _biome_rect_repository: BiomeRectRepository

func _enter_tree() -> void:
	_db = Injector.provide(GameDb, GameDb.new(), self)
	_biome_repository = Injector.provide(BiomeRepository, BiomeRepository.new(self), self)
	_biome_rect_repository = Injector.provide(BiomeRectRepository, BiomeRectRepository.new(self), self)

func _on_open_dialog_file_selected(path: String) -> void:
	_game_editor_state.open_editor_screen(path)

func _on_create_dialog_file_selected(path: String) -> void:
	_game_editor_state.open_editor_screen(path)

func _on_open_game_db_pressed() -> void:
	_open_dialog.show()

func _on_create_game_db_pressed() -> void:
	_create_dialog.show()

func _on_generate_chess_biomes_db_pressed() -> void:
	_generate_chess_dialog.show()
	
func _on_generate_chess_dialog_file_selected(path: String) -> void:
	_generate_chess_dialog.hide()
	#Callable(func ():
		#var width = _chess_map_width.text.to_int() if _chess_map_width.text.is_valid_int() else 0
		#var height = _chess_map_height.text.to_int() if _chess_map_height.text.is_valid_int() else 0
		#var squere_size = _chess_squere_size.text.to_int() if _chess_squere_size.text.is_valid_int() else 0
		#
		#if width <= 0 or height <= 0 or squere_size <= 0:
			#printerr("chess width, height and squere_size should be positive integers")
			#return
		#
		#_db.db_connect(path, _chess_big_optim.button_pressed)
		#
		#var even_biome = BiomeEntity.new()
		#even_biome.name = "forest"
		#even_biome.type = BiomeEntity.FOREST_TYPE
		#even_biome.id = _biome_repository.create(even_biome)
		#
		#var odd_biome = BiomeEntity.new()
		#odd_biome.name = "grass"
		#odd_biome.type = BiomeEntity.GRASS_TYPE
		#odd_biome.id = _biome_repository.create(odd_biome)
		#
		#if _chess_big_optim:
			#_db
		#
		#var progress_target = width * height
		#var rounded_progress: float = 0
		#for x in range(0, width):
			#for y in range(0, height):
				#var squere_x = floor(x / squere_size) 
				#var squere_y = floor(y / squere_size)
				#var biome = even_biome if (squere_x + squere_y) % 2 == 0 else odd_biome
				#var t = biome.type
				#var tile = TileEntity.new()
				#tile.position = Vector2i(x, y)
				#tile.biomes.push_back(biome.id)
				#
				#_tile_repository.create(tile)
				#
				#var new_progress = ((y * x + x) / progress_target)
				#var new_progress_rounded = floor(new_progress * 1000) / 1000
				#
				#if rounded_progress != new_progress_rounded:
					#rounded_progress = new_progress_rounded
					#_chess_progress.text = str(rounded_progress)
		##_db.create_indexes()
		#_db.db_close()
	#).call_deferred()
	
func get_random_int(a: int, b: int) -> int:
	return randi() % (b - a + 1) + a
func get_random_float(a: float, b: float) -> float:
	return randf() * (b - a + 1) + a

func _on_button_pressed() -> void:
	var w = 70
	var h = 35
	var c = 50
	
	_db.db_connect("res://databases/rect_big_30_1_2_2_gen.sqlite3", true)
	
	var even_biome = BiomeEntity.new()
	even_biome.name = "forest"
	even_biome.type = BiomeEntity.FOREST_TYPE
	even_biome.id = _biome_repository.create(even_biome)
	
	var odd_biome = BiomeEntity.new()
	odd_biome.name = "grass"
	odd_biome.type = BiomeEntity.GRASS_TYPE
	odd_biome.id = _biome_repository.create(odd_biome)
	
	var target_area = ceili(w * h * c * c * 1.2)
	
	while target_area > 0:
		var blot_center_rect = Rect2i(
			get_random_int(0, w * c * c),
			get_random_int(0, h * c * c),
			get_random_int(8, 30),
			get_random_int(8, 30)
		)
		var direction_rects = {
			"top": blot_center_rect,
			"right": blot_center_rect,
			"bottom": blot_center_rect,
			"left": blot_center_rect,
		}
		
		while(
			direction_rects["top"].size.x > 5 or
			direction_rects["right"].size.y > 5 or
			direction_rects["bottom"].size.x > 5 or
			direction_rects["left"].size.y > 5
		):
			var biome_id = even_biome.id if randf() > 0.5 else odd_biome.id
			
			if direction_rects["top"].size.x > 5:
				var rect = direction_rects["top"]
				var left_shift = get_random_int(1, floor(min(8, rect.size.x / 2)) - 1)
				var right_shift = get_random_int(1, floor(min(8, rect.size.x / 2)) - 1)
				var height = ceil(get_random_float(0.8, 1) * rect.size.y / 4)
				
				var new_rect = Rect2i(
					rect.position.x + left_shift,
					rect.position.y - height,
					rect.end.x - right_shift - (rect.position.x + left_shift),
					height
				)
				var new_rect_biome = BiomeRectEntity.new()
				new_rect_biome.rect = rect
				new_rect_biome.biome_id = biome_id
				
				_biome_rect_repository.create(new_rect_biome)
				target_area -= new_rect.get_area()
				direction_rects["top"] = new_rect
				
			if direction_rects["bottom"].size.x > 5:
				var rect = direction_rects["bottom"]
				var left_shift = get_random_int(1, floor(min(8, rect.size.x / 2)) - 1)
				var right_shift = get_random_int(1, floor(min(8, rect.size.x / 2)) - 1)
				var height = ceil(get_random_float(0.8, 1) * rect.size.y / 4)
				
				var new_rect = Rect2i(
					rect.position.x + left_shift,
					rect.end.y,
					rect.end.x - right_shift - (rect.position.x + left_shift),
					height
				)
				var new_rect_biome = BiomeRectEntity.new()
				new_rect_biome.rect = rect
				new_rect_biome.biome_id = biome_id
				
				_biome_rect_repository.create(new_rect_biome)
				target_area -= new_rect.get_area()
				direction_rects["bottom"] = new_rect
				
			if direction_rects["left"].size.y > 5:
				var rect = direction_rects["left"]
				var top_shift = get_random_int(1, floor(min(8, rect.size.y / 2)) - 1)
				var bottom_shift = get_random_int(1, floor(min(8, rect.size.y / 2)) - 1)
				var width = ceil(get_random_float(0.8, 1) * rect.size.x / 4)
				
				var new_rect = Rect2i(
					rect.position.x - width,
					rect.position.y + top_shift,
					width,
					rect.end.y - bottom_shift - (rect.position.y + top_shift)
				)
				var new_rect_biome = BiomeRectEntity.new()
				new_rect_biome.rect = rect
				new_rect_biome.biome_id = biome_id
				
				_biome_rect_repository.create(new_rect_biome)
				target_area -= new_rect.get_area()
				direction_rects["left"] = new_rect
				
			if direction_rects["right"].size.y > 5:
				var rect = direction_rects["right"]
				var top_shift = get_random_int(1, floor(min(8, rect.size.y / 2)) - 1)
				var bottom_shift = get_random_int(1, floor(min(8, rect.size.y / 2)) - 1)
				var width = ceil(get_random_float(0.8, 1) * rect.size.x / 4)
				
				var new_rect = Rect2i(
					rect.end.x,
					rect.position.y + top_shift,
					width,
					rect.end.y - bottom_shift - (rect.position.y + top_shift)
				)
				var new_rect_biome = BiomeRectEntity.new()
				new_rect_biome.rect = rect
				new_rect_biome.biome_id = biome_id
				
				_biome_rect_repository.create(new_rect_biome)
				target_area -= new_rect.get_area()
				direction_rects["right"] = new_rect
	_db.db_close()

	#var folder = "res://databases/test/"
	#var w = 70
	#var h = 35
	#var c = 50
	#for x in range(0, w):
		#for y in range(0, h):
			#var chunk = ChunkData.new()
			#chunk.name = "%d_%d" % [x, y]
			#for i in range(0, c * c):
				#var tile = {
					#"x": x,
					#"y": y,
					#"biomes": get_random_int(0, 2)
				#}
				#chunk._tiles.push_back(tile)
			#ResourceSaver.save(chunk, "%s%s.tres" % [folder, chunk.name])
