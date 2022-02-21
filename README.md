# qsdk for ax18

在ubuntu16.04 x64上编译通过。

依赖

```bash
sudo apt update
sudo apt-get install -y opam ocaml-nox git zip subversion build-essential flex wget gawk unzip man file zlib1g-dev libssl-dev libncurses5-dev python
```

编译

```bash
git clone https://github.com/felix-fly/qsdk-12.git
cd qsdk-12
cp ax18.config .config
make package/symlinks
make defconfig
make download -j$(nproc)
make -j$(nproc) V=s
```
