cd $TOP
git clone -b ariane-v0.7 https://github.com/lowRISC/buildroot.git
cd buildroot
cp configs/lowrisc_defconfig .config
make
