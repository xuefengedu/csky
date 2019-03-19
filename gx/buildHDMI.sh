apt-get install build-essential git lzip ncurses-dev minicom unzip bc -y
git clone https://github.com/c-sky/buildroot.git
cd buildroot
make csky_gx6605s_fbcon_br_defconfig
make
