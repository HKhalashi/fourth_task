#!/bin/bash
#for mask in "*.txt" "f*"; do find -name "$mask"; done | sort -u

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
        -h) echo "$0: rename files by suffix intersection in a directory and its subdirectories"
            echo "inssfx [-h] [-d|-v] [--] sfx dir mask1 [mask2...]"
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
dir=
mask_list=
error=
has_file=
echo "fifth flag: arg_4 = $4"
for arg in "$@"
 do
    if [[ $opt_sep || "${arg:0:1}" != "-" ]]
     then
        if [[ -z "$sfx" ]]
         then
             sfx="$arg"
         else
           if [[ -z $dir ]]
           then
                 dir="$arg"
           else
            has_mask=1
            #name="${arg%.*}"
            #ext="${arg#"$name"}"
            #newname="$name$sfx$ext"
            #my_arr_1+=("$my_var")
            curr_arg=
            echo "fourth flag: mask = $arg"
            mask_list+=($arg)

             #if [[ $opt_d || $opt_v ]]
              #then
                  #echo "$arg  -> $newname"

              #fi

             #if [[ -z $opt_d ]]
              #then
                  #if ! mv -- "$arg" "$newname"
                  #then
                       #error=1
                  #fi
                 #fi
               fi
             #echo File: "$arg" , name: "$name"  ext: "$ext"
             #echo "Non option: $arg"
         fi
     elif [[ "$arg" == "--" ]]
     then
      opt_sep=1

     fi
 done
if [[ "$sfx" != "" && "$dir" != "" && "$has_mask" != "" ]]
then
      if [[ $opt_d || $opt_v ]]
              then
                  echo "first flag: mask_list= ${mask_list[@]} "
                  echo "second flag: dir = $dir "
                  echo "third flag: sfx = $sfx "

                  #echo "$arg  -> $newname"
                  if ! for mask in mask_list; do find "$dir" -name "$mask"; done | sort -u | while read file; do bash first_task.bash -d "$sfx" $file; done
                  then
                        error=1
                 fi
              fi

             if [[ -z $opt_d ]]
              then
                  if ! for mask in mask_list; do find "$dir" -name "$mask"; done | sort -u | while read file; do bash first_task.bash "$sfx" $file; done
                  then
                       error=1
                  fi
                 fi
fi
if [[ -z $sfx ]]
 then
  echo "$0: no suffix given, try -h to help" >&2
            exit 2
elif [[ -z $dir ]]
then
   echo "$0: no directory given, try -h to help" >&2
   exit 2
elif [[ -z $has_mask ]]
then
  echo "$0: no file given, try -h to help" >&2
            exit 2
elif [[ $error ]]
 then
     exit 1
 else
      exit 0
fi




