class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/36/59/518760d90ab6ccf06f1954325b2e62274ccb82bbfaf3e40d341558789f44/crytic-compile-0.3.0.tar.gz"
  sha256 "4f672921124931137abfb48359bba66d85e8c71cda9ea780380f62bbc7a20e7d"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f3db6a44d52bcf9d929ffdc931f71dc66d2532cf5f8faddac360d4d9c3ee72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ce689ba323933cb83a9021ad2d61c161b75fc2135a471f41bafd6854d4c905b"
    sha256 cellar: :any_skip_relocation, ventura:        "fd4cdbd3b81023846db9217d684cd474abf8c8b46bacc4ce2b5e864f06400b37"
    sha256 cellar: :any_skip_relocation, monterey:       "df88c39d13cb0122344467b66b8e7f034b1c37233f5dca5c780c47c17c5a0089"
    sha256 cellar: :any_skip_relocation, big_sur:        "80119719686ffd01fdb79c060630e1e9f423ffc943e3cfd88d31919cee6d659c"
    sha256 cellar: :any_skip_relocation, catalina:       "0f5a8668fd5ff1b5b52986ad58089604879cdd178ecfbc872a8efc7f5e9d24d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636660a2cbc68a7052b2291156b827c57b4e8ee629124691d1d3ba882931b942"
  end

  depends_on "python@3.11"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/0d/66/5e4a14e91ffeac819e6888037771286bc1b86869f25d74d60bc4a61d2c1e/pycryptodome-3.16.0.tar.gz"
    sha256 "0e45d2d852a66ecfb904f090c3f87dc0dfb89a499570abad8590f10d9cffb350"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sol").write <<~EOS
      pragma solidity ^0.8.0;
      contract Test {
        function f() public pure returns (bool) {
          return false;
        }
      }
    EOS

    system "solc-select", "install", "0.8.0"
    with_env(SOLC_VERSION: "0.8.0") do
      system bin/"crytic-compile", testpath/"test.sol", "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end
