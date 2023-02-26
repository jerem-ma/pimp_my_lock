#!/bin/bash

PROGRAM_NAME=$0

# Args: <media> [<x> <y>] [<width>] [<height>]
_main()
{
	_parse_parameters "$@"
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

	# TODO Test if mpv could read the file
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
	value="$1"
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

# Args: <media> <x> <y> <width> <height> # TODO: Better fill this
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
	ffprobe -v error -select_streams v:0 -show_entries stream=width,height ~/conga/res/conga-343.mp4 | tail -n +2 | head -n -1 | sed -r 's/[^0-9]//g'
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
_main "$@"; exit
