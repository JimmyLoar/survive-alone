shader_type canvas_item;

// Настройки сетки
uniform vec2 grid_offset = vec2(0, 0); // Смещение сетки
uniform float square_size = 32.0; // Размер ячейки сетки
uniform float line_width = 1.0;  // Толщина линий
uniform float zoom = 1.0;  // Маштаб камеры, нужен для стабилизации отрисовки линий когда ее видимая толщина становится меньше пикселя

// Передаем мировые координаты из вершинного шейдера во фрагментный
varying vec2 world_pos;
void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}


// SDF функция для сетки
float square_grid_sdf(vec2 pos, float size, vec2 offset) {
    vec2 cell = fract((pos + offset) / size);
    vec2 dist = min(cell, 1.0 - cell);
    return min(dist.x, dist.y) * size;
}

void fragment() {
    // Вычисляем расстояние до ближайшей линии сетки
    float dist = square_grid_sdf(world_pos, square_size, grid_offset);
    
	float pixel_size = max(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
    float scaled_line_width = max(line_width / zoom, pixel_size);
	
	// Если растояние больше половины толщины линии то пиксель не на линии - нечего не рисуем
	if (dist > 0.5 * scaled_line_width) {
		discard;
	}
	
    // Цвет сетки (RGBA)
    vec4 grid_color = vec4(0.5, 0.5, 0.5, 0.2);

    // Смешиваем с исходным цветом пикселя (фоном) что бы убрать артефакты
    COLOR = mix(COLOR, grid_color, grid_color.a);
}