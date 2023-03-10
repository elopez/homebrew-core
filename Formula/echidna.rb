class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "c8e71f2b5900f019c8c4b81bb19626b486584fe63d2f9cdfad6ddd2a664a1d4c"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22e0fdba14807b7082ad3dd6fc6fdbed68970b847c5f003a1a60c06fca3c7d27"
    sha256 cellar: :any,                 arm64_big_sur:  "0be421a12ce86be7636cba0b5a245a353526b0970eb1fe1ee49006c6f313735f"
    sha256 cellar: :any,                 ventura:        "3b26fbc32bf5540014e482712e001d038b4d3420cfb6b3a21fabb283f15da6a6"
    sha256 cellar: :any,                 monterey:       "49c5d59d75c29b54a38e730517faa0436bc2f5e49807ec225fe4f0c4cfc0ad10"
    sha256 cellar: :any,                 big_sur:        "bcc1e052340a4009539a54f1ba302fbcbd3e8ed3780866e9e4fd8cd4ec8b3402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b3d9b40e7b1aadd4787cd06b97f46eda3c8a37b4b1c961dd09aaed72921d1f0"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build

  depends_on "crytic-compile"
  depends_on "libff"
  depends_on "secp256k1"
  depends_on "slither-analyzer"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{Formula["secp256k1"].include}",
      "--extra-lib-dirs=#{Formula["secp256k1"].lib}",
      "--flag=echidna:-static",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    system "solc-select", "install", "0.7.0"

    (testpath/"test.sol").write <<~EOS
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    EOS

    with_env(SOLC_VERSION: "0.7.0") do
      assert_match(/echidna_true:(\s+)passed!/,
                   shell_output("#{bin}/echidna --format text #{testpath}/test.sol"))
    end
  end
end
