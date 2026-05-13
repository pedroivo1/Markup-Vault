function optimize_mp4_g7
    # Force the use of dot for decimal places
    set -x LC_NUMERIC C

    # Colors for the log
    set color_info (set_color cyan)
    set color_success (set_color green)
    set color_error (set_color red)
    set color_warn (set_color yellow)
    set color_reset (set_color normal)

    # Define the root path (argument 1 or the CURRENT folder)
    set ROOT_PATH $argv[1]
    if test -z "$ROOT_PATH"
        set ROOT_PATH $PWD
    end

    # Check if the folder exists
    if not test -d "$ROOT_PATH"
        echo -s $color_error "Error: The folder '$ROOT_PATH' does not exist!" $color_reset
        return 1
    end

    # Count how many files end with " - o.mp4"
    set TOTAL_FILES (find "$ROOT_PATH" -type f -name "* - o.mp4" | wc -l)

    if test $TOTAL_FILES -eq 0
        echo -s $color_warn "No files ending with ' - o.mp4' found in $ROOT_PATH." $color_reset
        return 0
    end

    echo ""
    echo -s $color_info "Found $TOTAL_FILES videos to process in: $ROOT_PATH" $color_reset

    # Recursive search with smart sorting (sort -zV)
    find "$ROOT_PATH" -type f -name "* - o.mp4" -print0 | sort -zV | while read -lz video_file

        if test -z "$video_file"
            continue
        end

        # Define the output name by removing only the final " - o"
        set output_file (string replace -r " - o\.mp4\$" ".mp4" "$video_file")

        set base_name (basename "$video_file")
        set new_name (basename "$output_file")

        # Check if the final file already exists
        if test -f "$output_file"
            echo -s $color_warn "Warning: The final file already exists: '$new_name'. Skipping." $color_reset
            continue
        end

        echo ""
        echo -s $color_info "Processing: " $color_reset $base_name

        # --- Resolution and QP Logic (GPU) ---
        set video_height (ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$video_file" 2>/dev/null)

        if test -z "$video_height"
            echo -s $color_warn " └─ Warning: Resolution not detected. Using default QP 32." $color_reset
            set target_qp 32
        else
            if test $video_height -le 480
                set target_qp 28
            else if test $video_height -le 720
                set target_qp 32
            else if test $video_height -le 1080
                set target_qp 34
            else
                set target_qp 36
            end
            echo " └─> Resolution: "$video_height"p | Target QP: $target_qp"
        end

        # --- FPS Logic ---
        set raw_fps (ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$video_file" 2>/dev/null)

        if test -z "$raw_fps"
            echo -s $color_error " └─ Error: FPS not detected. Skipping file." $color_reset
            continue
        end

        set fps (echo "scale=3; $raw_fps" | bc -l 2>/dev/null)

        set target_fps (awk -v fps="$fps" 'BEGIN {
            fps_fmt = sprintf("%.2f", fps)
            if (fps_fmt == "29.97" || fps_fmt == "59.94") {
                print 29.97
            } else if (fps_fmt == "60.00" || fps_fmt == "30.00" || fps_fmt == "24.00") {
                print 24
            } else {
                print 24
            }
        }')

        # --- Dynamic GOP Logic (2 Seconds) based on TARGET FPS ---
        set target_gop (awk -v fps="$target_fps" 'BEGIN { printf "%.0f", fps * 2 }')

        echo " └─> Original FPS: $fps | Target: $target_fps"
        echo " └─> Keyframes (GOP): Every $target_gop frames (2s)"
        echo " └─> Destination: $new_name"

        # Display the FFMPEG command on screen before running
        echo " └─> FFMPEG Command:"
        echo "     ffmpeg -nostdin -hide_banner -loglevel warning -stats -n -vaapi_device /dev/dri/renderD128 -i \"$video_file\" -vf \"format=nv12,hwupload\" -c:v hevc_vaapi -qp \"$target_qp\" -g \"$target_gop\" -r \"$target_fps\" -c:a aac -b:a 64k \"$output_file\""

        # --- FFMPEG Command (Accelerated by AMD GPU + Dynamic GOP) ---
        ffmpeg -nostdin -hide_banner -loglevel warning -stats -n \
               -vaapi_device /dev/dri/renderD128 \
               -i "$video_file" \
               -vf "format=nv12,hwupload" \
               -c:v hevc_vaapi -qp "$target_qp" -g "$target_gop" -r "$target_fps" \
               -c:a aac -b:a 64k \
               "$output_file"

        if test $status -eq 0
            echo -s $color_success " └─ Success! Optimized video created." $color_reset
        else
            echo -s $color_error " └─ Error converting the file." $color_reset
            rm -f "$output_file"
        end

    end

    echo ""
    echo -s $color_success "--- Recursive Processing Completed ---" $color_reset
end
