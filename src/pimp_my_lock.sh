#!/bin/bash

PROGRAM_NAME=$0

# Args: <media> [<x> <y>] [<width>] [<height>]
_main()
{
	_check_dependencies
	_parse_parameters "$@"

	ft_lock
	_wait_for_ft_lock
	read -d "\n" window_id pid <<< $(_start_media "$MEDIA" "$POS_X" "$POS_Y" "$W_WIDTH" "$W_HEIGHT")
	_bring_window_to_top "$window_id"
	_resize_window "$window_id" "$W_WIDTH" "$W_HEIGHT"
	_move_window "$window_id" "$POS_X" "$POS_Y"
	_wait_for_ft_lock_end
	kill $pid
}

_check_dependencies()
{
	local dependencies=(ft_lock head column sed cat mediainfo tail pqiv mpv xwininfo grep awk wmctrl xdotool)
	for dependency in ${dependencies[@]}; do
		command -v $dependency > /dev/null 2>&1
		if [[ $? -ne 0 ]]; then
			echo "$dependency is not installed !" >&2
			exit 1
		fi
	done
}

# Args: Same as main
_validate_parameters()
{
	if [ $# -lt 1  ]; then
		_help
		exit 1
	fi
	if [ $# -eq 2 ]; then
		echo "y must be provided if x is provided !" >&2
		_help
		exit 1
	fi

	local media="$1"
	local x="$2"
	local y="$3"
	local width="$4"
	local height="$5"

	if [ ! -f "$media" ]; then
		echo "$0: $media: No such file or directory" >&2
		exit 1
	fi
	if [ ! -r "$media" ]; then
		echo "$0: $media: Permission denied" >&2
		exit 1
	fi

	if [[ $# -ge 2 ]] && ! _is_valid_x "$x"; then
		echo "$0: $x: Invalid argument" >&2
		_help
		exit 1
	fi

	if [[ $# -ge 3 ]] && ! _is_valid_y "$y"; then
		echo "$0: $y: Invalid argument" >&2
		_help
		exit 1
	fi

	if [[ $# -ge 4 ]] && ! _is_valid_size "$width"; then
		echo "$0: $width: Invalid argument" >&2
		_help
		exit 1
	fi

	if [[ $# -ge 5 ]] && ! _is_valid_size "$height"; then
		echo "$0: $height: Invalid argument" >&2
		_help
		exit 1
	fi
}

# Args: <x>
_is_valid_x()
{
	if [ $# -lt 1 ]; then
		echo "Usage: $0 <x>" >&2
	fi
	local x="$1"
	is_pixel_or_percent "$x" || [[ "$x" = "left" || "$x" = "center" || "$x" = "right" ]]
	return $?
}

# Args: <y>
_is_valid_y()
{
	if [ $# -lt 1 ]; then
		echo "Usage: "$0" <y>" >&2
	fi
	local y="$1"
	is_pixel_or_percent "$y" || [[ "$y" = "top" || "$y" = "center" || "$y" = "bottom" ]]
	return $?
}

# Args: <size>
_is_valid_size()
{
	if [ $# -lt 1 ]; then
		echo "Usage: $0 <size>" >&2
	fi
	local size="$1"
	is_pixel_or_percent "$size"
	return $?
}

# Args: <value>
is_pixel_or_percent()
{
	if [ $# -lt 1 ]; then
		echo "Usage: $0 <value>" >&2
	fi
	local value="$1"
	[[ "$value" =~ ^[0-9]+%?$ ]]
	return $?
}

_help()
{
	echo "Usage: $PROGRAM_NAME <media> [<x> <y>] [<width>] [<height>]"
	echo ''

	column -L -t -s "	" << EOF
<media>	:	Path to media. Must be a file readable by mpv
<x>	:	Position of media in x axis. See POSITION for accepted values
<y>	:	Position of media in y axis. See POSITION for accepted values
<width>	:	Width of media. See SIZE for accepted values
<height>	:	Width of media. See SIZE for accepted values
EOF
	echo ''

	cat << EOF
--- POSITION ---
Value must be provided either:
- In pixel
- In percentage of the screen followed by the sign '%'
- With one of these keywords:
	+ For x: left, center, right
	+ For y: top, center, bottom

--- SIZE ---
Value must be provided either:
- In pixel
- In percentage of the screen followed by the sign '%'
EOF
}

# Return: <width>\n<height>
_get_screen_size()
{
	# TODO: Check if it is still working with multiple monitors
	# https://superuser.com/questions/196532/how-do-i-find-out-my-screen-resolution-from-a-shell-script
	cat /sys/class/graphics/*/virtual_size | head -n1 | sed 's/,/\n/'
}

# Args: <media> <x> <y> <width> <height>
_parse_parameters()
{
	MEDIA=$1
	local x=$2
	local y=$3
	local width=$4
	local height=$5
	_validate_parameters "$@"
	read -d "\n" S_WIDTH S_HEIGHT <<< $(_get_screen_size)
	read -d "\n" M_WIDTH M_HEIGHT <<< $(_get_media_size $MEDIA)

	if [[ -z "$width" ]]; then
		W_WIDTH=$((S_WIDTH/10)) # 10 * S_WIDTH / 100
	else
		read W_WIDTH <<< $(_convert_size "$width" "$S_WIDTH")
	fi
	if [[ -z "$height" ]]; then
		W_HEIGHT=$((W_WIDTH*M_HEIGHT/M_WIDTH))
	else
		read W_HEIGHT <<< $(_convert_size "$height" "$S_HEIGHT")
	fi

	if [[ -z "$x" ]]; then
		POS_X=$(((S_WIDTH - W_WIDTH)/2))
	else
		read POS_X <<< $(_convert_pos "$x" "$S_WIDTH" "$W_WIDTH")
	fi
	if [[ -z "$y" ]]; then
		POS_Y=$(((S_HEIGHT - W_HEIGHT)/2))
	else
		read POS_Y <<< $(_convert_pos "$y" "$S_HEIGHT" "$W_HEIGHT")
	fi
}

# Args: <media>
_get_media_size()
{
	if [[ $# -lt 1 ]]; then
		echo "Usage: $0 <media>" >&2
		exit 1
	fi
	local media="$1"
	mediainfo "$media" | grep -E "(Width|Height)" | awk '{print $3}'
}

# Args: <size> <max_size>
# Return: <converted_size>
_convert_size()
{
	if [[ $# -lt 2 ]]; then
		echo "Usage: $0 <size> <max_size>" >&2
		exit 1
	fi
	local size=$1
	local max_size=$2
	if [[ $size = *"%" ]]; then
		size=$(echo $size | sed 's/%//g')
		size=$((size * max_size / 100))
	fi
	echo "$size"
}

# Args: <pos> <screen_size> <window_size>
# Return: <converted_pos>
_convert_pos()
{
	if [[ $# -lt 3 ]]; then
		echo "Usage: $0 <pos> <screen_size> <window_size>" >&2
		exit 1
	fi
	local pos=$1
	local screen_size=$2
	local window_size=$3
	if [[ $pos = "left" || $pos = "top" ]]; then
		pos=0
	elif [[ $pos = "center" ]]; then
		pos=50%
	elif [[ $pos = "right" || $pos = "bottom" ]]; then
		pos=100%
	fi
	if [[ $pos = *"%" ]]; then
		pos=$(echo $pos | sed 's/%//g')
		m=$((screen_size - window_size))
		pos=$((m * pos / 100))
	fi
	echo $pos
}

# Args: <media> <x> <y> <width> <height>
# Return: <window_id>\n<pid>
_start_media()
{
	if [ $# -lt 5 ]; then
		echo "Usage: $0 <media> <x> <y> <width> <height>" >&2
		exit 1
	fi
	local media="$1"
	local x="$2"
	local y="$3"
	local width="$4"
	local height="$5"
	if [[ $media =~ ^.*\.gif$ ]]; then
		pqiv -i -c --action="set_scale_mode_fit_px($width, $height)" $media > /dev/null 2>&1 &
	else
		mpv $media --no-input-terminal --geometry="${width}x${height}+${x}+${y}" --loop > /dev/null 2>&1 &
	fi
	local pid=$!
	local window_media_id=$(_wait_for_window_id_from_pid "$pid")
	echo -e "$window_media_id\n$pid"
}

# Args: <pid>
# Return: window id
_wait_for_window_id_from_pid()
{
	if [ $# -lt 1 ]; then
		echo "Usage: $0 <pid>" >&2
		exit 1
	fi
	local pid=$1
	local viewable_success=1
	while [[ $viewable_success -ne 0 ]]; do
		local win_id=$(wmctrl -l -p | awk "{if (\$3 == $pid) print \$1"})
		xwininfo -id $win_id 2> /dev/null | grep "IsViewable" > /dev/null 2>&1
		local viewable_success=$?
	done
	echo $win_id
}

_wait_for_ft_lock()
{
	# TODO Check if it is the right process and not an other window named ft_lock
	until (xwininfo -name ft_lock 2> /dev/null | grep "IsViewable" > /dev/null 2>&1) ; do
		true
	done
}

# Args: <window_id>
_bring_window_to_top()
{
	if [ $# -lt 1 ]; then
		echo "Usage: $0 <window_id>" >&2
		exit 1
	fi
	local window_id=$1
	xdotool set_window --overrideredirect 1 $window_id
	xdotool windowunmap --sync $window_id
	xdotool windowmap --sync $window_id
	xdotool windowraise $window_id
}

# Args: <window_id> <x> <y>
_move_window()
{
	if [ $# -lt 3 ]; then
		echo "Usage: $0 <window_id> <x> <y>" >&2
		exit 1
	fi
	local window_id="$1"
	local x="$2"
	local y="$3"
	sleep 1
	xdotool windowmove --sync "$window_id" "$x" "$y"
}

# Args: <window_id> <width> <height>
_resize_window()
{
	if [ $# -lt 3 ]; then
		echo "Usage: $0 <window_id> <width> <height>" >&2
		exit 1
	fi
	local window_id="$1"
	local width="$2"
	local height="$3"
	xdotool windowsize --sync "$window_id" "$width" "$height"
}

_wait_for_ft_lock_end()
{
	LAST_SECOND=$SECONDS
	while (xwininfo -name ft_lock > /dev/null 2>&1) ; do
		if [[ $LAST_SECOND -ne $SECONDS ]]; then
			xdotool click 1
			LAST_SECOND=$SECONDS
		fi
		sleep .1
	done
}

_main "$@"; exit
