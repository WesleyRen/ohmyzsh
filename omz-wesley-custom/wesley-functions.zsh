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
