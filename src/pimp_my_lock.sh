#!/bin/bash

PROGRAM_NAME=$0

# Args: <media> [<x> <y>] [<width>] [<height>]
_main()
{
	
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
