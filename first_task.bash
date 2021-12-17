#!/bin/bash


opt_v=
opt_d=
opt_set=
for arg in "$@"
 do
    if [[ "${arg:0:1}" == "-" && -z "$opt_set" ]]
     then
        case $arg in
        -v) opt_v=1
           ;;
        -d) opt_d=1
           ;;
        -h) echo "$0: rename file by suffix intersection"
            echo "usage: $0 [-v] [-d] [--] suffix files..."
            echo "-d : dry run {do not rename}"
            echo "-v : verbose output"
            echo "-- : option and non-option argument separator"
            exit 0
            ;;
        --) opt_set=1
           ;;
         *) echo "$0: invalid option '$arg', try -h to help" >&2
            exit 2
            ;;
          esac
        fi
done


opt_sep=
sfx=
error=
has_file=
for arg in "$@"
 do
    if [[ "$opt_sep" || "${arg:0:1}" != "-" ]]
     then
        if [[ -z "$sfx" ]]
         then
             sfx="$arg"
         else
             has_file=1
             name="${arg%.*}"
             ext="${arg#"$name"}"
             newname="$name$sfx$ext"


             if [[ $opt_d || $opt_v ]]
              then
                  echo "$arg  -> $newname"
              fi

             if [[ -z $opt_d ]]
              then
                  if ! mv -- "$arg" "$newname"
                  then
                       error=1
                  fi

               fi
             #echo File: "$arg" , name: "$name"  ext: "$ext"
             #echo "Non option: $arg"
         fi
     elif [[ "$arg" == "--" ]]
     then
      opt_sep=1

     fi
 done

if [[ -z $sfx ]]
 then
  echo "$0: no suffix given, try -h to help" >&2
            exit 2
elif [[ -z $has_file ]]
then
  echo "$0: no file given, try -h to help" >&2
            exit 2

elif [[ $error ]]
 then
     exit 1
 else
      exit 0
fi




