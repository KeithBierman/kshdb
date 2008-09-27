# -*- shell-script -*-
# filecache.sh - cache file information
#
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

# Keys are the canonic expanded filename. 
# name of variable which contains text.
typeset -T Fileinfo_t=(
    size=-1
    typeset -a text=()
    integer mtime=-1
)

Fileinfo_t -A _Dbg_filenames
_Dbg_filenames=()

# Maps a name into its canonic form which can then be looked up in filenames
typeset -A _Dbg_file2canonic
_Dbg_file2canonic=()

function _Dbg_readfile # var file
{
   nameref var=$1
   set -f	      
   IFS=$'\n\n'
   var=( $(< $2))
}

# Read $1 into _DBG_source_*n* array where *n* is an entry in
# _Dbg_filenames.  Variable _Dbg_seen[canonic-name] will be set to
# note the file has been read and the filename will be saved in array
# _Dbg_filenames

_Dbg_readin() {
    typeset filename
    if (($# != 0)) ; then 
	filename="$1"
    else
	_Dbg_frame_file
	filename="$_Dbg_frame_filename"
    fi

    if [[ -z $filename ]] || [[ $filename == _Dbg_bogus_file ]] ; then 
	# FIXME
	return 2
    else 
	typeset fullname=$(_Dbg_resolve_expand_filename $filename)
	if [[ ! -r $fullname ]] ; then
	    return 1
	fi
    fi
    
    typeset -a text
    _Dbg_readfile text "$fullname"
    _Dbg_file2canonic[$filename]="$fullname"
    _Dbg_file2canonic[$fullname]="$fullname"
    _Dbg_filenames[$fullname].size=${#text[@]}
    # _Dbg_filenames[$fullname].text=text
    return 0
}


# _Dbg_is_file echoes the full filename if $1 is a filename found in files
# '' is echo'd if no file found. Return 0 (in $?) if found, 1 if not.
function _Dbg_is_file {
  if (( $# == 0 )) ; then
    _Dbg_errmsg "Internal debug error: null file to find"
    echo ''
    return 1
  fi
  typeset find_file="$1"

  if [[ ${find_file[0]} == '/' ]] ; then 
      # Absolute file name
      if [[ -n ${_Dbg_filenames[$find_file]} ]] ; then
	  print -- "$find_file"
	  return 0
      fi
  elif [[ ${find_file[0]} == '.' ]] ; then
      # Relative file name
      try_find_file=$(_Dbg_expand_filename ${_Dbg_init_cwd}/$find_file)
      # FIXME: turn into common subroutine
      if [[ -n ${_Dbg_filenames[$try_find_file]} ]] ; then
	  print -- "$try_find_file"
	  return 0
      fi
  else
    # Resolve file using _Dbg_dir
    typeset -i n=${#_Dbg_dir[@]}
    typeset -i i
    for (( i=0 ; i < n; i++ )) ; do
      typeset basename="${_Dbg_dir[i]}"
      if [[  $basename == '\$cdir' ]] ; then
	basename=$_Dbg_cdir
      elif [[ $basename == '\$cwd' ]] ; then
	basename=$(pwd)
      fi
      try_find_file="$basename/$find_file"
      if [[ -f "$try_find_file" ]] ; then
	  print -- "$try_find_file"
	  return 0
      fi
    done
  fi
  echo ''
  return 1
}

# Check that line $2 is not greater than the number of lines in 
# file $1
_Dbg_check_line() {
  typeset -i line_number=$1
  typeset filename=$2
#   typeset -i max_line=$(_Dbg_get_maxline $filename)
#   if (( $line_number >  max_line )) ; then 
#     (( _Dbg_basename_only )) && filename=${filename##*/}
#     _Dbg_err_msg "Line $line_number is too large." \
#       "File $filename has only $max_line lines."
#     return 1
#   fi
  return 0
}
