# Wesley's functions.

# Usage: monitor_disk /dev/disk3s1s1 10
function monitor_disk() {
    local fs="$1"
    local interval=10
    local count=0
    local header_interval=25

    if [ -z "$fs" ]; then
        echo "Usage: monitor_disk <filesystem> [interval_seconds]"
        echo "Example: monitor_disk /dev/disk3s1s1 10"
        return 1
    fi

    [ -n "$2" ] && interval="$2"

    df -h | head -1 | awk '{printf "%-15s %5s %5s %5s %6s %8s %5s %5s %6s %s %s\n", "Filesystem", "Size", "Used", "Avail", "Use%", "IUsed", "IFree", "%IUse", "Mounted", "on", "Timestamp"}'

    while true; do
        if [ $((count % header_interval)) -eq 0 ] && [ $count -ne 0 ]; then
            df -h | head -1 | awk '{printf "%-15s %5s %5s %5s %6s %8s %5s %5s %6s %s %s\n", "Filesystem", "Size", "Used", "Avail", "Use%", "IUsed", "IFree", "%IUse", "Mounted", "on", "Timestamp"}'
        fi

        df -h | grep -e "$fs" | awk -v date="$(date '+%Y-%m-%d %H:%M:%S')" '{printf "%-15s %5s %5s %5s %6s %8s %5s %5s %6s %s %s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, date}'

        ((count++))
        sleep "$interval"
    done
}

gfetch() {
  local branch="$1"
  git fetch origin "$branch" --depth=1 && git checkout -b "$branch" FETCH_HEAD
}

dusort() {
  du -hs "$@" | sort -h
}


# temporary stuff because crazy SNow env.
###
# Local utils for glide instance
# 1. find and shutdown all local Glide instances.
# 2. list all installation
###
glide_util() {
  case "$1" in
    shutdown)
      ps -ef | grep java | grep "target/install" | awk '{for(i=1;i<=NF;i++) if($i ~ /target\/install\/[^ ]+/) print $i}' | \
      while read -r install_path; do
        clean_path=$(echo "$install_path" | sed 's/^-D[^=]*=//')
        dir=$(echo "$clean_path" | grep -o '.*target/install/[^/]*')
        shutdown_script="$dir/shutdown.sh"
        if [ -x "$shutdown_script" ]; then
          echo "Shutting down: $shutdown_script"
          "$shutdown_script"
        else
          echo "Shutdown script not found or not executable: $shutdown_script"
        fi
      done
      ;;
    list)
      dirs=()
      for d in /Users/wesley.ren/stuff/s-now/git/*/*-test/target/install; do
        [ -d "$d" ] && dirs+=("$d")
      done

      echo "Install directories:"
      for d in "${dirs[@]}"; do
        echo "$d"
      done
      echo

      for d in "${dirs[@]}"; do
        for subdir in "$d"/*; do
          if [ -d "$subdir" ]; then
            ls -ld "$subdir" | awk '{print $6, $7, $8, $9}' | sed "s|$d/||"
          fi
        done
      done
      ;;
    delete)
      dirs=()
      for d in /Users/wesley.ren/stuff/s-now/git/*/*-test/target/install; do
        [ -d "$d" ] && dirs+=("$d")
      done

      if [ ${#dirs[@]} -eq 0 ]; then
        echo "No install directories found."
        return 1
      fi

      echo "Available install directories:"
      echo "[0] Delete ALL listed directories"
      idx=1
      for d in "${dirs[@]}"; do
        echo "[$idx] $d"
        idx=$((idx + 1))
      done

      printf "Select a directory number to delete (blank to cancel): "
      IFS= read -r choice
      if [ -z "$choice" ]; then
        echo "Deletion cancelled."
        return 0
      fi

      if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -gt ${#dirs[@]} ]; then
        echo "Invalid selection."
        return 1
      fi

      if [ "$choice" -eq 0 ]; then
        echo "Directories to delete:"
        printf '%s\n' "${dirs[@]}"
        printf "Type 'delete all' to confirm removing ALL directories above (anything else cancels): "
        IFS= read -r confirm_all
        if [ "$confirm_all" = "delete all" ]; then
          for target_dir in "${dirs[@]}"; do
            rm -rf "$target_dir"
            echo "Deleted: $target_dir"
          done
        else
          echo "Deletion cancelled."
        fi
        return 0
      fi

      target_dir="${dirs[$((choice - 1))]}"
      echo "Contents under $target_dir:"
      find "$target_dir" -mindepth 1 -maxdepth 1 -type d -print

      printf "Type 'delete' to confirm removing '%s' (anything else cancels): " "$target_dir"
      IFS= read -r confirm
      if [ "$confirm" = "delete" ]; then
        rm -rf "$target_dir"
        echo "Deleted: $target_dir"
      else
        echo "Deletion cancelled."
      fi
      ;;
  esac
}

size_loop() {
    local target_path="$1"
    local interval="${2:-60}"

    if [[ -z "$target_path" ]]; then
        echo "usage: size_loop <file_or_directory> [interval_seconds]" >&2
        return 2
    fi

    local start_time
    start_time=$(date +%s)

    local i=0
    local size=""

    echo "target_path: $target_path"

    while true; do
        ((i++))

        if [[ ! -f "$target_path" && ! -d "$target_path" ]]; then
            echo "[$target_path] doesn't exist!" >&2
            return 1
        fi

        local new_size
        new_size=$(du -hs "$target_path" | cut -f1)

        if [[ "$size" == "$new_size" ]]; then
            echo "[$target_path] size is stable"
            return 0
        fi

        local now elapsed
        now=$(date +%s)
        elapsed=$((now - start_time))

        printf "size %s, iteration %03d, time elapsed: %d minutes, %d seconds\n" \
            "$new_size" "$i" "$((elapsed / 60))" "$((elapsed % 60))"

        size="$new_size"
        sleep "$interval"
    done
}
