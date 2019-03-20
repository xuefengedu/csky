# Scripts

## Debian pass

```
docker build --build-arg rootpassword=newpassword -t "xuefengedu/c-sky:debian" debian
cd /test;mkdir code
docker run --privileged=true -v /test/code:/code xuefengedu/c-sky:debian /bin/bash
docker exec -it <container_id|container_name> /bin/bash
chmod 777 /code
cd /code;
git clone https://github.com/c-sky/buildroot.git
cd buildroot
make csky_gx6605s_br_defconfig
make
```

## Ubuntu 16.04 failed for https://github.com/c-sky/forum/issues/72

```
docker build --build-arg rootpassword=newpassword -t "xuefengedu/c-sky:ubuntu16.04" ubuntu16.04
cd /test;mkdir code
docker run --privileged=true -v /test/code:/code xuefengedu/c-sky:ubuntu16.04
docker exec -it <container_id|container_name> /bin/bash
locale-gen en_US.UTF-8
chmod 777 /code
cd /code;
git clone https://github.com/c-sky/buildroot.git
cd buildroot
make csky_gx6605s_br_defconfig
make
```

