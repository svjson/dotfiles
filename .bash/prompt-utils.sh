
abbreviate_path() {
  local path="$1"
  local base_limit="${2:-30}"
  local max_length

  # Replace $HOME with ~
  if [[ "$path" == "$HOME"* ]]; then
    path="~${path#$HOME}"
  fi

  # If the path is just `~` or has no subdirectories, return as-is
  if [[ "$path" == "~" || "$path" == "/*" ]]; then
    echo "$path"
    return
  fi

  # Split path into segments
  local IFS='/'
  read -ra segments <<< "$path"

  local segment_count=${#segments[@]}
  local first="${segments[0]}"
  local last="${segments[-1]}"
  local middle=("${segments[@]:1:${#segments[@]}-2}")

  # Determine max length dynamically
  max_length=$(( base_limit + (segment_count * SEG_LIMIT_FACTOR) ))

  # Handle the case where the path starts with `~`
  local keep_start=1
  if [[ "$first" == "~" ]]; then
    keep_start=2
  fi

  # Construct the initial abbreviated path
  local abbreviated_path=""
  local i=0

  # Keep the first (or first two if starting with `~`) segments intact
  while (( i < keep_start )); do
    abbreviated_path+="${segments[i]}/"
    ((i++))
  done

  # Add the remaining segments without shortening
  for (( ; i < segment_count - 1; i++ )); do
    abbreviated_path+="${segments[i]}/"
  done

  # Add the last segment
  abbreviated_path+="$last"

  # If the full path fits, return it
  if (( ${#abbreviated_path} <= max_length )); then
    echo "$abbreviated_path"
    return
  fi

  # Now we start shortening from **left to right**
  i=$keep_start
  while (( ${#abbreviated_path} > max_length && i < segment_count - 1 )); do
    # Only shorten if the segment isn't already a single letter
    if (( ${#segments[i]} > 1 )) && [[ "${segments[i]}" != .* ]]; then
      # Replace the segment with its first letter
      segments[i]="${segments[i]:0:1}"
    fi

    # Rebuild the path with the shortened segment
    abbreviated_path=""
    for (( j = 0; j < segment_count - 1; j++ )); do
      abbreviated_path+="${segments[j]}/"
    done
    abbreviated_path+="$last"

    ((i++))
  done

  echo "$abbreviated_path"
}

abbreviate_path_orgg () {
  local path="$1"
  local max_length="${2:-30}"
  local IFS='/'

  # Replace $HOME with ~
  if [[ "$path" == "$HOME"* ]]; then
    path="~${path#$HOME}"
  fi
  read -ra segments <<< "$path"

  # If there are 2 or fewer segments, no abbreviation needed
  if (( ${#segments[@]} <= 2 )); then
    echo "$path"
    return
  fi

  local first="${segments[0]}"
  local last="${segments[-1]}"
  local middle=("${segments[@]:1:${#segments[@]}-2}")

  # Construct the full path without abbreviation
  local full_path="$first/$(IFS=/; echo "${middle[*]}")/$last"

  # If the full path fits within the limit, return it
  if (( ${#full_path} <= max_length )); then
    echo "$full_path"
    return
  fi

  # Otherwise, start abbreviating the middle segments
  local abbreviated=""
  for segment in "${middle[@]}"; do
    abbreviated+="${segment:0:1}/"
  done

  # Construct the abbreviated path
  local abbreviated_path="$first/$abbreviated$last"

  # If the abbreviated path fits, return it
  if (( ${#abbreviated_path} <= max_length )); then
    echo "$abbreviated_path"
  else
    # If even that doesn't fit, drop middle segments one-by-one until it does
    while (( ${#abbreviated_path} > max_length && ${#middle[@]} > 0 )); do
      middle=("${middle[@]:1}")
      abbreviated=""
      for segment in "${middle[@]}"; do
        abbreviated+="${segment:0:1}/"
      done
      abbreviated_path="$first/$abbreviated$last"
    done

    echo "$abbreviated_path"
  fi
}

parse_git_branch() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  git symbolic-ref --quiet --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null
}

