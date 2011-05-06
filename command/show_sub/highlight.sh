# -*- shell-script -*-
# "show highlight" debugger command
#
#   Copyright (C) 2011 Rocky Bernstein <rocky@gnu.org>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; see the file COPYING.  If not, write to
#   the Free Software Foundation, 59 Temple Place, Suite 330, Boston,
#   MA 02111 USA.

_Dbg_help_add_sub show highlight \
"Show syntax highlight of listings" 1

_Dbg_do_show_highlight() {
    typeset label="$1"
    [[ -n $label ]] && label='highlight: '
    _Dbg_msg_nocr \
        "${label}Syntax highlight in source listings is "
    if (( $_Dbg_set_highlight == 0)) ; then
        _Dbg_msg 'off.'
    else
        _Dbg_msg 'on.'
    fi
    return 0
}