class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/23.08.4/src/kcachegrind-23.08.4.tar.xz"
  sha256 "7cf17ae3b87c2b4c575f2eceddae84b412f5f6dfcee8a0f15755e6eed3d22b04"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "83931c0f4bd3aa09247b4a4b43a66f99182999cd9596ca39356e167fc1dd18b0"
    sha256 cellar: :any,                 arm64_ventura:  "53f43d7da188d69de361c4d847973c7098e643bdf1d8fb300adb79b34e3e93ae"
    sha256 cellar: :any,                 arm64_monterey: "5cccc97fd25ff420d0c851b897a552f4a937e7f9f500ca3380a65cb7aa42cfae"
    sha256 cellar: :any,                 sonoma:         "c2c4d294e35761f6b02b33ed9e80cfe1565dc65cc94859741bedc9fdc3f7f16c"
    sha256 cellar: :any,                 ventura:        "9356b96df76abca58580eca9e3dc40a7b2b87facc197ba01aa136a8f2a902491"
    sha256 cellar: :any,                 monterey:       "2e36347c0d4403f0107ce5cce58c8233cfd5d55df40711c4b219ce6f1ce3ca19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008f3c220d327e1724827b6d371f248a6b3747f68bf5b01922a2cf32774f5ef3"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = []
    if OS.mac?
      # TODO: when using qt 6, modify the spec
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
    end

    system Formula["qt@5"].opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
