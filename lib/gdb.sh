# -*- shell-script -*-
# gdb.sh - routines that seem tailored more to the gdb-style of doing things.
#   Copyright (C) 2008 Rocky Bernstein rocky@gnu.org
#
#   kshdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   kshdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#   
#   You should have received a copy of the GNU General Public License along
#   with kshdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# Print location in gdb-style format: file:line
# So happens this is how it's stored in global _Dbg_frame_stack which
# is where we get the information from

# Print location in gdb-style format: file:line
# So happens this is how it's stored in global _Dbg_frame_stack which
# is where we get the information from
function _Dbg_print_location {
    typeset -i pos=${1:-$_Dbg_stack_pos}
    typeset -n frame=_Dbg_frame_stack[pos]
    typeset filename=${frame.filename}
    typeset fn=${frame.fn}
    ((_Dbg_basename_only)) && filename=${filename##*/}
    _Dbg_msg "(${filename}:${frame.lineno}):"
}

# Print position $1 of stack frame (from global _Dbg_frame_stack)
# Prefix the entry with $2 if that's set.
function _Dbg_print_frame {
    typeset -i pos=${1:-$_Dbg_stack_pos}
    typeset prefix=${2:-''}

    [[ -z ${_Dbg_frame_stack[pos].filename} ]] && return
    _Dbg_msg "$prefix ${_Dbg_frame_stack[pos].to_file_line}"
}