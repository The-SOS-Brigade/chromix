echo ================
echo Building Chromix
echo ================

sudo apt install -y \
  docker.io \
  docker-compose \
  qemu-system-x86

cd catgirls
sudo docker-compose up

sudo qemu-system-x86_64 -hda dist/drive
# enter user: `chromix`
su
# enter password: `toor`
xinit
