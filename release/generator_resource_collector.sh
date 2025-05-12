#!/bin/bash
res_path="/mnt/nvme0/MyProjects/Godot/survive-alone/resources/collection"
script="/mnt/nvme0/MyProjects/Godot/survive-alone/databases/resources_collector.gd"
uid=""

# Заголовок файла с большим предупреждением
cat > "$script" <<EOL
class_name ResourceCollector
extends Object

#######################################################################
#                                                                     #
# WARNING: АВТОМАТИЧЕСКИ СГЕНЕРИРОВАННЫЙ ФАЙЛ!                       #
# НЕ РЕДАКТИРОВАТЬ ВРУЧНУЮ!                                          #
# ЛЮБЫЕ ИЗМЕНЕНИЯ БУДУТ ПЕРЕЗАПИСАНЫ ПРИ ОЧЕРЕДНОЙ ГЕНЕРАЦИИ!        #
#                                                                     #
#######################################################################


EOL

declare -A collections

function update_uid {
    local string=$(<$1)
    string="${string#*uid=}"
    uid="${string%%]*}"
}

function process_file {
    local full_path=$1
    local file=$2
    local rel_path="${full_path#$res_path/}"
    local collection_name=$(echo "$rel_path" | cut -d'/' -f1)
    local item_name="${file%.*}"

    update_uid "$full_path/$file"

    if [[ -z "${collections[$collection_name]}" ]]; then
        collections[$collection_name]="const ${collection_name} = {\n"
    fi
    collections[$collection_name]+="    \"${item_name}\": ${uid},\n"
}

function scan_directory {
    local dir=$1
    for entry in "$dir"/*; do
        if [[ -d "$entry" ]]; then
            scan_directory "$entry"
        elif [[ -f "$entry" ]]; then
            process_file "$(dirname "$entry")" "$(basename "$entry")"
        fi
    done
}

echo "Generating ResourceCollector..."
scan_directory "$res_path"

# Разделитель перед коллекциями
echo -e "\n#######################################################################" >> "$script"
echo -e "# КОЛЛЕКЦИИ РЕСУРСОВ                                                 #" >> "$script"
echo -e "#######################################################################\n" >> "$script"

# Запись коллекций
for collection_name in "${!collections[@]}"; do
    content=$(echo -e "${collections[$collection_name]}" | sed '$s/,\s*$//')
    echo -e "${content}\n}" >> "$script"
    echo >> "$script"
done

# Разделитель перед enum
echo -e "\n#######################################################################" >> "$script"
echo -e "# ТИПЫ КОЛЛЕКЦИЙ                                                     #" >> "$script"
echo -e "#######################################################################\n" >> "$script"

# Enum для типов коллекций
echo "enum Collection {" >> "$script"
for collection_name in "${!collections[@]}"; do
    upper_name=$(echo "$collection_name" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')
    echo "    ${upper_name}," >> "$script"
done
echo "}" >> "$script"

# Разделитель перед методами
echo -e "\n#######################################################################" >> "$script"
echo -e "# МЕТОДЫ ДЛЯ РАБОТЫ С РЕСУРСАМИ                                      #" >> "$script"
echo -e "#######################################################################\n" >> "$script"

# Основные методы
cat >> "$script" <<EOL

static func uid(collection: Collection, key: String) -> String:
    """Возвращает UID ресурса или пустую строку если не найден"""
    match collection:
EOL

for collection_name in "${!collections[@]}"; do
    upper_name=$(echo "$collection_name" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')
    echo "        Collection.${upper_name}:" >> "$script"
    echo "            return ${collection_name}.get(key, \"\")" >> "$script"
done
echo "        _: return \"\"" >> "$script"

cat >> "$script" <<EOL

static func find(collection: Collection, key: String) -> Resource:
    """Загружает и возвращает один ресурс"""
    var resource_uid := uid(collection, key)
    return ResourceLoader.load(resource_uid) if resource_uid else null

static func find_multiple(collection: Collection, keys: Array[String]) -> Array:
    """Загружает и возвращает массив ресурсов по массиву ключей"""
    var result: Array[Resource] = []
    for key in keys:
        var res := find(collection, key)
        if res:
            result.append(res)
    return result

static func find_all(collection: Collection) -> Array:
    """Возвращает все ресурсы указанной коллекции"""
    var result: Array[Resource] = []
    for key in keys(collection):
        var res := find(collection, key)
        if res:
            result.append(res)
    return result

static func keys(collection: Collection) -> Array:
    """Возвращает все ключи указанной коллекции"""
    match collection:
EOL

for collection_name in "${!collections[@]}"; do
    upper_name=$(echo "$collection_name" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')
    echo "        Collection.${upper_name}:" >> "$script"
    echo "            return ${collection_name}.keys()" >> "$script"
done
echo "        _: return []" >> "$script"

# Финальное предупреждение
echo -e "\n#######################################################################" >> "$script"
echo -e "# КОНЕЦ АВТОМАТИЧЕСКИ СГЕНЕРИРОВАННОГО ФАЙЛА                        #" >> "$script"
echo -e "#######################################################################" >> "$script"

echo "ResourceCollector generation complete!"
