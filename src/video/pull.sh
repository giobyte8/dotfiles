
# Pulls video files from rbx that are pending to be transocoded
function tr-pull() {

    remote="rock@192.168.100.130:/home/rock/workspace/downloads/complete/transcode_pending/"
    dest="$HOME/Movies/Transcoding/Pending"

    rsync -hruz --progress "$remote" "$dest"
}
