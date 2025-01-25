DIR="./junaga-chroot-demo"
mkdir $DIR/bin
mkdir $DIR/lib
mkdir $DIR/lib64

copy() {
  for BIN in "$@"
  do
    cp $BIN $DIR/bin/

    # Get the list of dependencies for the binary
    LIBS=$(ldd $BIN | grep -o '/[^ ]*')
    for LIB in $LIBS
    do
      # Copy each dependency
      cp --parents $LIB $DIR/
    done
  done
}

copy "/bin/bash /bin/ls"

chroot $DIR /bin/bash
echo "Chroot demo completed."
