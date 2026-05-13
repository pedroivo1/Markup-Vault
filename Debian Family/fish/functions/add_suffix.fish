function add_suffix
    # Process flags: look for -r or --recursive
    argparse 'r/recursive' -- $argv
    or return 1 # Stop if the user passes an invalid flag (e.g., -x)

    # What remains in $argv after argparse is our text
    set suffix $argv[1]

    # Validation: check if the user forgot to pass the suffix
    if test -z "$suffix"
        echo -s (set_color red) "Error: You need to provide the desired suffix." (set_color normal)
        echo -s (set_color yellow) "Usage: " (set_color normal) "add_suffix [-r] \"suffix\""
        return 1
    end

    # Colors for the log
    set color_info (set_color cyan)
    set color_success (set_color green)
    set color_warn (set_color yellow)
    set color_reset (set_color normal)

    set counter 0

    # Configure the base find command
    set find_args . -type f

    # If the -r flag was NOT activated, limit find to the current folder only (maxdepth 1)
    if not set -q _flag_r
        set -a find_args -maxdepth 1
        echo -s $color_info "Searching for files in the " (set_color -o) "CURRENT FOLDER" (set_color normal) $color_info " to add '$suffix'..." $color_reset
    else
        echo -s $color_info "Searching for files " (set_color -o) "RECURSIVELY" (set_color normal) $color_info " to add '$suffix'..." $color_reset
    end

    echo ""

    # Execute the search
    find $find_args -print0 | sort -zV | while read -lz file_path

        if test -z "$file_path"
            continue
        end

        # Isolate the file name and its directory path
        set dir_path (dirname "$file_path")
        set filename (basename "$file_path")

        # Prevention: ignore hidden system files (starting with a dot, e.g., .gitignore)
        if string match -q ".*" "$filename"
            continue
        end

        # Extract the extension and the base name
        set ext (string match -r '\.[^\.]+$' "$filename")
        if test -n "$ext"
            set base_name (string replace -r '\.[^\.]+$' '' "$filename")
        else
            set base_name "$filename"
            set ext ""
        end

        # Prevention: ignore if the base name already ends with the suffix
        if string match -q "*$suffix" "$base_name"
            # Remove the "./" from the beginning to make the log prettier
            set log_path (string replace -r '^\./' '' "$file_path")
            echo -s $color_warn "Ignored (already has the suffix): " $color_reset "'$log_path'"
            continue
        end

        # Construct the new name and the final path
        set new_name "$base_name$suffix$ext"
        set output_path "$dir_path/$new_name"

        # Rename the file
        mv "$file_path" "$output_path"
        set counter (math $counter + 1)

        # Remove the "./" from the beginning for the log
        set log_path_orig (string replace -r '^\./' '' "$file_path")
        set log_path_dest (string replace -r '^\./' '' "$output_path")

        echo -s $color_success "Renamed: " $color_reset "'$log_path_orig' -> '$new_name'"
    end

    echo ""
    echo -s $color_info "Done! $counter files were renamed." $color_reset
end
