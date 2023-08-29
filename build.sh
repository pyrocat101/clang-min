set -eux

curl -L "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/$NAME.tar.xz" -o src.tar.xz
tar "$WILDCARDS_FLAG" -xvf src.tar.xz \
  "$NAME/bin/clang-16" \
  "$NAME/bin/clang++" \
  "$NAME/bin/clang-cpp" \
  "$NAME/bin/lld" \
  "$NAME/bin/ld.lld" \
  "$NAME/bin/llvm-objcopy" \
  "$NAME/bin/llvm-strip" \
  "$NAME/bin/llvm-libtool-darwin" \
  "$NAME/bin/llvm-ar" \
  "$NAME/bin/llvm-as" \
  "$NAME/bin/llvm-nm" \
  "$NAME/lib/clang/16/include/*.h" \
  "$NAME/include/c++/v1"

cd "$NAME"

pushd bin
  if [  -z "NO_STRIP" ]; then
    strip -SXx ./clang-16
    # clang++ and clang-cpp are symlinks
    strip -SXx ./lld
    # ld.lld is a symlink
    strip -SXx ./llvm-objcopy
    # llvm-strip is a symlink
    strip -SXx ./llvm-ar
    strip -SXx ./llvm-as
    strip -SXx ./llvm-nm
    strip -SXx ./llvm-libtool-darwin
  fi;

  mv clang-16 clang

  # Fake some tools we don't care about.
  touch llvm-profdata
  touch llvm-cov
  touch llvm-objdump
  touch llvm-dwp
popd

tar -cJf "../$NAME.tar.xz" bin/ lib/ include/
