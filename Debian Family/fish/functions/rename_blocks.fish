function rename_blocks
    # Colors to make the log readable
    set color_info (set_color cyan)
    set color_success (set_color green)
    set color_warn (set_color yellow)
    set color_reset (set_color normal)

    # Define the root path (argument 1 or the CURRENT folder)
    set ROOT_PATH $argv[1]
    if test -z "$ROOT_PATH"
        set ROOT_PATH $PWD
    end

    if not test -d "$ROOT_PATH"
        echo "Error: The folder '$ROOT_PATH' does not exist."
        return 1
    end

    echo -s $color_info "Starting recursive scan in: $ROOT_PATH" $color_reset
    set renamed_files 0

    # Use recursive find with print0 to support names with spaces
    find "$ROOT_PATH" -type f -print0 | while read -lz file

        if test -z "$file"
            continue
        end

        # Isolate the file name and its directory path
        set base_name (basename "$file")
        set dir_path (dirname "$file")
        set dir_name (basename "$dir_path")

        # Extract n1: The lesson number (taken from the file's parent folder)
        set n1 (echo "$dir_name" | grep -oE '[0-9]+' | head -n 1)

        # Extract n2: The block number (taken from the file name)
        # Regex updated to accept both English and Portuguese conventions safely
        set n2 (echo "$base_name" | grep -ioE '(BLOCK|BLOCO) [0-9]+' | grep -oE '[0-9]+')

        # If any of the numbers are missing, silently ignore this file
        if test -z "$n1"; or test -z "$n2"
            continue
        end

        # Get the original extension
        set extension (string split -r -m1 . "$base_name")[-1]

        # Construct the new name with the " - o" suffix
        set new_name "Lesson $n1 - Block $n2 - o.$extension"
        set output_file "$dir_path/$new_name"

        # Check if the file already has the correct name to avoid useless renaming
        if test "$file" = "$output_file"
            continue
        end

        # Rename the file
        mv "$file" "$output_file"
        set renamed_files (math $renamed_files + 1)

        echo -s $color_warn "Renamed: " $color_reset "'$base_name'"
        echo -s $color_success "       ->: " $color_reset "'$new_name'"
    end

    echo -s "\n" $color_info "Done! $renamed_files files were renamed." $color_reset
end
