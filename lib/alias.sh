# -*- shell-script -*-
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

# Command aliases are stored here.
typeset -A _Dbg_aliases

# Add an new alias in the alias table
function _Dbg_add_alias {
    (( $# != 2 )) && return 1
    _Dbg_aliases[$1]=$2
    return 0
}

# Remove alias $1 from our list of command aliases.
function _Dbg_remove_alias {
    (( $# != 1 )) && return 1
    unset "_Dbg_aliases[$1]"
    return 0
}

# Expand alias $1. The result is set in variable expanded_alias which
# could be declared local in the caller.
function _Dbg_expand_alias {
    (( $# != 1 )) && return 1
    expanded_alias=$1
    [[ -n ${_Dbg_aliases[$1]} ]] && expanded_alias=${_Dbg_aliases[$1]}
    return 0
}