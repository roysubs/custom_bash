# rename all the files which contain uppercase letters to lowercase in the current folder
function filestolower(){
  read -p "This will rename all the files and directories to lowercase in the current folder, continue? [y/n]: " letsdothis
  if [ "$letsdothis" = "y" ] || [ "$letsdothis" = "Y" ]; then
    for x in `ls`
      do
      skip=false
      if [ -d $x ]; then
    read -p "'$x' is a folder, rename it? [y/n]: " renamedir
    if [ "$renamedir" = "n" ] || [ "$renameDir" = "N" ]; then
      skip=true
    fi
      fi
      if [ "$skip" == "false" ]; then
        lc=`echo $x  | tr '[A-Z]' '[a-z]'`
        if [ $lc != $x ]; then
          echo "renaming $x -> $lc"
          mv $x $lc
        fi
      fi
    done
  fi
}
