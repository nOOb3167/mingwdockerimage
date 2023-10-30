# This is a template of configuration file for MXE. See
# index.html for more extensive documentations.

# This variable controls the number of compilation processes
# within one package ("intra-package parallelism").
JOBS := 32

# This variable controls the targets that will build.
MXE_TARGETS :=  x86_64-w64-mingw32.shared

MXE_PLUGIN_DIRS := plugins/gcc13

# The three lines below makes `make` build these "local packages" instead of all packages.
# The ordering of the list appears weird, but this seems to help to get the build done
# faster on a massively parallel machine to get some of the bottleneck packages built as
# early as possible
LOCAL_PKG_LIST := gcc \
                  openssl \
                  libmysqlclient \
                  postgresql \
                  qtbase \
                  qtwebkit \
                  nsis \
                  curl \
                  libxml2 \
                  libxslt \
                  libzip \
                  libusb1 \
                  hidapi \
                  libgit2 \
                  libftdi1 \
                  mdbtools \
                  qtconnectivity \
                  qtdeclarative \
                  qtimageformats \
                  qtlocation \
                  qtmultimedia \
                  qtquickcontrols \
                  qtquickcontrols2 \
                  qtcharts \
                  qtsvg \
                  qttools \
                  qttranslations \
                  zstd
.DEFAULT local-pkg-list:
local-pkg-list: $(LOCAL_PKG_LIST)
