# -*- shell-script -*-
# frame.sh - gdb-like "up", "down" and "frame" debugger commands
#
#   Copyright (C) 2008 Rocky Bernstein rocky@gnu.org
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; see the file COPYING.  If not, write to
#   the Free Software Foundation, 59 Temple Place, Suite 330, Boston,
#   MA 02111 USA.

# Move default values down $1 or one in the stack. 

_Dbg_help_add frame \
'frame [FRAME-NUM] -- Move the current frame to the FRAME-NUM.

If FRAME-NUM is negative, count back from the least-recent frame; -1
is the oldest frame. FRAME-NUM can be any arithmetic expression. If
FRAME is omitted, 0 or the most-recent frame moved to.' 1

_Dbg_do_frame() {
    _Dbg_not_running && return 1
    typeset -i pos=${1:-0}
    _Dbg_frame_adjust $pos 0
    typeset -i rc=$?
    ((0 == rc)) && _Dbg_last_cmd='frame'
    _Dbg_print_location
}
