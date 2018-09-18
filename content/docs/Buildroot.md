cd $TOP
git clone -b refresh-v0.6 https://github.com/lowRISC/buildroot.git
cd buildroot
cp configs/lowrisc_defconfig .config
make
