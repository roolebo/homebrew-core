class I686ElfGcc < Formula
  desc "The GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-9.3.0/gcc-9.3.0.tar.xz"
  sha256 "71e197867611f6054aa1119b13a0c0abac12834765fe2d81f35ac57f84f742d1"

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "i686-elf-binutils"

  def install
    mkdir "i686-elf-gcc-build" do
      system "../configure", "--target=i686-elf",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/i686-elf-gcc",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["i686-elf-binutils"].bin}/i686-elf-as",
                             "--with-ld=#{Formula["i686-elf-binutils"].bin}/i686-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # localization files may conflict with native gcc
      (share/"locale").rmtree
      # FSF-related man pages may conflict with native gcc
      (share/"man/man7").rmtree
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-i368",
      shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
  end
end
