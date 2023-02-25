#!/bin/bash

PROGRAM_NAME=$0

# Args: <media> [<x> <y>] [<width>] [<height>]
_main()
{
	_validate_parameters "$@"
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

	if ! _is_valid_x "$x"; then
		echo "$0: $x: Invalid argument" >&2
		_help
		exit 1
	fi

	if ! _is_valid_y "$y"; then
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

_main "$@"; exit
