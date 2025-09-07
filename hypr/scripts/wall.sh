#!/bin/bash

# Function to print errors in red
error() {
    echo -e "\e[31mERROR: $1\e[0m" >&2
}

# Function to print info in green
info() {
    echo -e "\e[32m[INFO] $1\e[0m"
}

# Function to print warnings in yellow
warn() {
    echo -e "\e[33m[WARNING] $1\e[0m"
}

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        error "Required command '$1' not found. Please install it and try again."
        exit 1
    fi
}

# Function to show help message
show_help() {
    echo "Usage: $(basename "$0") [OPTIONS] WALLPAPER CONFIG [COLOR_COUNT]"
    echo
    echo "Change wallpaper and apply color scheme to configuration files"
    echo
    echo "Options:"
    echo "  -h, --help         Show this help message and exit"
    echo "  -d, --dry-run      Don't modify any files, just preview changes"
    echo "  -v, --verbose      Show detailed processing information"
    echo "  -f, --force        Overwrite destination files without prompting"
    echo "  -n, --no-wallpaper Don't change the wallpaper, just update themes"
    echo "  -l, --light        Use light mode (light background, dark foreground)"
    echo
    echo "Arguments:"
    echo "  WALLPAPER          Path to wallpaper image file"
    echo "  CONFIG             Path to JSON configuration file mapping template files to output files"
    echo "  COLOR_COUNT        Number of colors to extract (default: 16)"
    echo
    echo "Example config.json format:"
    echo '{
  [
    ["/path/to/template1.txt", "/path/to/output1.txt"],
    ["/path/to/template2.txt", "/path/to/output2.txt"]
  ]
}'
    exit 0
}

# Default settings
DRY_RUN=false
VERBOSE=false
FORCE=false
NO_WALLPAPER=false
LIGHT_MODE=false
COLOR_COUNT=16
EXTRACT_COUNT=24  # Extract more colors than needed to have better selection
COLOR_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -c|--color-mode)
            COLOR_MODE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -n|--no-wallpaper)
            NO_WALLPAPER=true
            shift
            ;;
        -l|--light)
            LIGHT_MODE=true
            shift
            ;;
        *)
            if [ -z "$WALLPAPER" ]; then
                WALLPAPER="$1"
            elif [ -z "$CONFIG" ]; then
                CONFIG="$1"
            elif [ -z "$USER_COLOR_COUNT" ]; then
                USER_COLOR_COUNT="$1"
                # Validate color count is a positive integer
                if ! [[ "$USER_COLOR_COUNT" =~ ^[1-9][0-9]*$ ]]; then
                    error "Color count must be a positive integer."
                    exit 1
                fi
                COLOR_COUNT="$USER_COLOR_COUNT"
            else
                error "Too many arguments. Use --help for usage information."
                exit 1
            fi
            shift
            ;;
    esac
done

# Check required arguments
if [ -z "$WALLPAPER" ]; then
    error "Wallpaper path is required."
    show_help
fi

if [ -z "$CONFIG" ]; then
    error "Config path is required."
    show_help
fi

# Check required commands
check_command "jq"
check_command "gowall"
check_command "pastel"
check_command "perl"

# Check if files exist
if [ ! -f "$WALLPAPER" ]; then
    error "Wallpaper file not found: $WALLPAPER"
    exit 1
fi

if [ ! -f "$CONFIG" ]; then
    error "Config file not found: $CONFIG"
    exit 1
fi

# Try to get real paths
wallpath=$(realpath "$WALLPAPER" 2>/dev/null || echo "$WALLPAPER")
configpath=$(realpath "$CONFIG" 2>/dev/null || echo "$CONFIG")

info "Starting theme generation with wallpaper: $wallpath"
info "Using config file: $configpath"
info "Mode: $([ "$LIGHT_MODE" = true ] && echo "Light" || echo "Dark")"
info "Color mode: $([ "$COLOR_MODE" = true ] && echo "On" || echo "Off")"
info "Extracting $EXTRACT_COUNT colors for processing"

# Check if config is valid JSON
if ! jq empty "$configpath" 2>/dev/null; then
    error "Config file is not valid JSON."
    exit 1
fi

# Set wallpaper if not in dry run mode and wallpaper changing is enabled
if [ "$DRY_RUN" = false ] && [ "$NO_WALLPAPER" = false ]; then
    if command -v swww &> /dev/null; then
        info "Setting wallpaper with swww"
        if ! swww img "$wallpath"  --transition-fps 255 --transition-type center --transition-duration 3.0 2>/dev/null; then
            warn "Failed to set wallpaper with swww. Is swww daemon running?"
            if command -v swaybg &> /dev/null; then
                info "Trying swaybg instead"
                swaybg -i "$wallpath" -m fill &
            elif command -v feh &> /dev/null; then
                info "Trying feh instead"
                feh --bg-fill "$wallpath"
            else
                warn "Could not find alternative wallpaper setter. Wallpaper not changed."
            fi
        fi
    elif command -v swaybg &> /dev/null; then
        info "Setting wallpaper with swaybg"
        swaybg -i "$wallpath" -m fill &
    elif command -v feh &> /dev/null; then
        info "Setting wallpaper with feh"
        feh --bg-fill "$wallpath"
    else
        warn "No supported wallpaper setter found (swww, swaybg, or feh). Wallpaper not changed."
    fi
fi



# Extract colors from wallpaper
info "Extracting colors from wallpaper"
colors=$(gowall extract -c "$EXTRACT_COUNT" "$wallpath" 2>/dev/null)
if [ $? -ne 0 ]; then
    error "Failed to extract colors from wallpaper using gowall."
    exit 1
fi


# Convert colors to array and get luminance values
declare -a orig_colors
declare -a luminance_values
declare -a final_colors

IFS=$'\n' read -d '' -ra orig_colors <<< "$colors"

# Check if any extracted colors
if [ ${#orig_colors[@]} -eq 0 ]; then
    error "No colors extracted from wallpaper."
    exit 1
fi

# Calculate luminance for each color and store in parallel array
info "Analyzing colors for optimal contrast"
for color in "${orig_colors[@]}"; do
    # Get luminance using pastel
    lum=$(pastel format luminance "$color" 2>/dev/null || echo "0.5")
    luminance_values+=("$lum")
done

# Function to calculate contrast ratio between two colors
# Formula: (L1 + 0.05) / (L2 + 0.05) where L1 is the lighter color
calculate_contrast() {
    local lum1="$1"
    local lum2="$2"
    
    # Ensure lum1 is the larger value
    if (( $(echo "$lum1 < $lum2" | bc -l) )); then
        local temp="$lum1"
        lum1="$lum2"
        lum2="$temp"
    fi
    
    # Calculate contrast ratio
    local contrast=$(echo "scale=2; ($lum1 + 0.05) / ($lum2 + 0.05)" | bc)
    echo "$contrast"
}

# Find optimal foreground and background colors based on mode
if [ "$LIGHT_MODE" = true ]; then
    # Light mode: Find lightest color for background and darkest for foreground
    bg_index=0
    fg_index=0
    highest_lum=0
    lowest_lum=1
    
    for i in "${!luminance_values[@]}"; do
        lum="${luminance_values[$i]}"
        
        # Find lightest color for background
        if (( $(echo "$lum > $highest_lum" | bc -l) )); then
            highest_lum="$lum"
            bg_index="$i"
        fi
        
        # Find darkest color for foreground
        if (( $(echo "$lum < $lowest_lum" | bc -l) )); then
            lowest_lum="$lum"
            fg_index="$i"
        fi
    done
else
    # Dark mode: Find darkest color for background and lightest for foreground
    bg_index=0
    fg_index=0
    highest_lum=0
    lowest_lum=1
    
    for i in "${!luminance_values[@]}"; do
        lum="${luminance_values[$i]}"
        
        # Find darkest color for background
        if (( $(echo "$lum < $lowest_lum" | bc -l) )); then
            lowest_lum="$lum"
            bg_index="$i"
        fi
        
        # Find lightest color for foreground
        if (( $(echo "$lum > $highest_lum" | bc -l) )); then
            highest_lum="$lum"
            fg_index="$i"
        fi
    done
fi

# Calculate contrast between optimal foreground and background
contrast=$(calculate_contrast "${luminance_values[$fg_index]}" "${luminance_values[$bg_index]}")

# If contrast is too low, try to find a better foreground color
if (( $(echo "$contrast < 4.5" | bc -l) )); then
    info "Initial contrast too low ($contrast). Finding better foreground color..."
    best_contrast=0
    
    for i in "${!luminance_values[@]}"; do
        if [ "$i" -ne "$bg_index" ]; then
            current_contrast=$(calculate_contrast "${luminance_values[$i]}" "${luminance_values[$bg_index]}")
            
            if (( $(echo "$current_contrast > $best_contrast" | bc -l) )); then
                best_contrast="$current_contrast"
                fg_index="$i"
            fi
        fi
    done
    
    contrast="$best_contrast"
fi

# Create the final colors array, starting with foreground and background
final_colors[0]="${orig_colors[$fg_index]}"  # color1 = foreground
final_colors[1]="${orig_colors[$bg_index]}"  # color2 = background

info "Selected colors for optimal contrast:"
info "  Foreground (color1): ${final_colors[0]} (luminance: ${luminance_values[$fg_index]})"
info "  Background (color2): ${final_colors[1]} (luminance: ${luminance_values[$bg_index]})"
info "  Contrast ratio: $contrast"

# Prepare an array of remaining colors (excluding fg and bg)
declare -a remaining_colors
declare -a remaining_lum
declare -a remaining_h
declare -a remaining_s
declare -a remaining_v

for i in "${!orig_colors[@]}"; do
    if [ "$i" -ne "$fg_index" ] && [ "$i" -ne "$bg_index" ]; then
        remaining_colors+=("${orig_colors[$i]}")
        remaining_lum+=("${luminance_values[$i]}")
    fi
done

# Sort remaining colors by hue first, then by saturation
# This is a simple sort - for complex sorting, you'd use Python or another language
declare -a sorted_indices
for i in "${!remaining_colors[@]}"; do
    sorted_indices+=("$i")
done

# Bubble sort by luminance
for ((i=0; i<${#sorted_indices[@]}; i++)); do
    for ((j=0; j<${#sorted_indices[@]}-i-1; j++)); do
        idx1="${sorted_indices[$j]}"
        idx2="${sorted_indices[$j+1]}"
        
        if (( $(echo "${remaining_lum[$idx1]} < ${remaining_lum[$idx2]}" | bc -l) )); then
            temp="${sorted_indices[$j]}"
            sorted_indices[$j]="${sorted_indices[$j+1]}"
            sorted_indices[$j+1]="$temp"
        fi
    done
done

# Add sorted colors to final array
for idx in "${sorted_indices[@]}"; do
    if [ "${#final_colors[@]}" -lt "$COLOR_COUNT" ]; then
        final_colors+=("${remaining_colors[$idx]}")
    else
        break
    fi
done

# If we don't have enough colors, pad with variations
while [ "${#final_colors[@]}" -lt "$COLOR_COUNT" ]; do
    # Use pastel to lighten/darken some existing colors
    idx=$(( RANDOM % ${#final_colors[@]} ))
    lighten=$(( RANDOM % 2 ))
    
    if [ "$lighten" -eq 1 ]; then
        new_color=$(pastel lighten 0.1 "${final_colors[$idx]}" 2>/dev/null || echo "${final_colors[$idx]}")
    else
        new_color=$(pastel darken 0.1 "${final_colors[$idx]}" 2>/dev/null || echo "${final_colors[$idx]}")
    fi
    
    final_colors+=("$new_color")
done

# Trim to desired color count if we extracted more
if [ "${#final_colors[@]}" -gt "$COLOR_COUNT" ]; then
    final_colors=("${final_colors[@]:0:$COLOR_COUNT}")
fi

# Display final color palette
if [ "$VERBOSE" = true ]; then
    info "Final color palette:"
    for i in "${!final_colors[@]}"; do
        pastel color ${final_colors[$i]} | pastel format hex
        colornum=$((i+1))
        lum=$(pastel format luminance "${final_colors[$i]}" 2>/dev/null || echo "N/A")
        echo -e "  color$colornum: \e[38;2;$(pastel format rgb "${final_colors[$i]}" | tr -d 'rgb()' | tr ',' ';')m${final_colors[$i]}\e[0m (luminance: $lum)"
    done
fi

# Process each template/output pair
info "Processing template files according to config"
success_count=0
error_count=0
jq -c '.[]' "$configpath" 2>/dev/null | while read -r pair; do
    # Get source and destination paths
    from=$(jq -r '.[0]' <<< "$pair" 2>/dev/null)
    to=$(jq -r '.[1]' <<< "$pair" 2>/dev/null)
    
    # Handle realpath manually for each path
    from=$(realpath "$from" 2>/dev/null || echo "$from")
    to=$(realpath "$to" 2>/dev/null || echo "$to")
    
    if [ -z "$from" ] || [ -z "$to" ]; then
        warn "Invalid pair in config: $pair"
        ((error_count++))
        continue
    fi
    
    if [ "$VERBOSE" = true ]; then
        info "Processing: $from -> $to"
    fi
    
    # Check if template file exists
    if [ ! -f "$from" ]; then
        error "Template file not found: $from"
        ((error_count++))
        continue
    fi
    
    # Check if destination directory exists
    to_dir=$(dirname "$to")
    if [ ! -d "$to_dir" ]; then
        if [ "$DRY_RUN" = false ]; then
            warn "Destination directory doesn't exist. Creating: $to_dir"
            mkdir -p "$to_dir" || {
                error "Failed to create directory: $to_dir"
                ((error_count++))
                continue
            }
        else
            warn "Destination directory doesn't exist (would create in real run): $to_dir"
        fi
    fi
    
    # Check if destination file exists and user hasn't forced overwrite
    if [ -f "$to" ] && [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
        read -p "File exists: $to. Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            warn "Skipping $to (not overwriting)"
            continue
        fi
    fi
    
    # Read template content
    output=$(cat "$from" 2>/dev/null)
    if [ $? -ne 0 ]; then
        error "Failed to read template file: $from"
        ((error_count++))
        continue
    fi
    
    # Find all unique color references
    color_refs=$(echo "$output" | grep -oP '{{[[:space:]]*\K(color[0-9]+)(?=\.[a-z-]+[[:space:]]*}})' | sort -u)
    
    # Check if any variables found
    if [ -z "$color_refs" ]; then
        warn "No color variables found in template: $from"
        if [ "$DRY_RUN" = false ]; then
            # Just copy the file as-is
            cp "$from" "$to" 2>/dev/null || {
                error "Failed to copy file to: $to"
                ((error_count++))
                continue
            }
        fi
        continue
    fi
    
    # Process each unique color reference
    for color_ref in $color_refs; do
        index="${color_ref#color}"
        
        if [[ "$index" =~ ^[0-9]+$ ]]; then
            # Check if index is in range
            if [ "$index" -gt "${#final_colors[@]}" ]; then
                warn "Color reference $color_ref is out of range. Only ${#final_colors[@]} colors available."
                continue
            fi
            
            ((index--))  # Convert to 0-based indexing
            hex="${final_colors[$index]}"
            
            # Find all format variations for this color
            formats=$(echo "$output" | grep -oP "{{[[:space:]]*$color_ref\.\K([a-z-]+)(?=[[:space:]]*}})" | sort -u)
            
            # Process each format for this color
            for format in $formats; do
                var="$color_ref.$format"
                
                if [ "$VERBOSE" = true ]; then
                    info "  Replacing $var with color ${final_colors[$index]} in $format format"
                fi
                
                # Format the color
                formatted=$(pastel format "$format" "$hex" | tr -d "#" 2>/dev/null)
                if [ $? -ne 0 ]; then
                    warn "Failed to format color $hex to $format. Using hex format instead."
                    formatted="$hex"
                fi
                
                # Replace variable with formatted color
                output=$(echo "$output" | perl -pe "s/{{\\s*$var\\s*}}/$formatted/g" 2>/dev/null)
                if [ $? -ne 0 ]; then
                    error "Failed to replace color variables in template."
                    ((error_count++))
                    continue 2
                fi
            done
        else
            warn "Invalid color reference: $color_ref"
        fi
    done
    
    # Write output if not in dry run mode
    if [ "$DRY_RUN" = false ]; then
        echo "$output" > "$to" 2>/dev/null
        if [ $? -ne 0 ]; then
            error "Failed to write output to: $to"
            ((error_count++))
            continue
        fi
        info "Successfully wrote: $to"
        ((success_count++))
    else
        info "Would write to: $to (dry run)"
        ((success_count++))
    fi
done

# Display summary
if [ "$DRY_RUN" = true ]; then
    info "Dry run completed. $success_count files would be processed. $error_count errors encountered."
else
    info "Theme generation complete. $success_count files processed successfully. $error_count errors encountered."
fi

# Notify user of theme change if notify-send is available
dunstctl reload
if [ "$DRY_RUN" = false ] && command -v notify-send &> /dev/null; then
    notify-send "Theme Updated" "Applied new color scheme based on wallpaper" -i "$wallpath" -t 3000
fi

exit $error_count
