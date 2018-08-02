## HDD
sudo mount /dev/sda /home/ssg-test/HDD

## ramdisk
sudo mkdir /dev/shm/tmp
sudo chmod 1777 /dev/shm/tmp
sudo mount --bind /dev/shm/tmp /home/ssg-test/ramdisk

##emu_pmem
sudo mkfs.ext4 /dev/pmem0    OR    sudo mkfs.xfs /dev/pmem0
sudo mount -o dax /dev/pmem0 /home/ssg-test/emu_pmem
