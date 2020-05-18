class I386ElfBinutils < Formula
  desc "GNU Binutils for i386-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.gz"
  sha256 "53537d334820be13eeb8acb326d01c7c81418772d626715c7ae927a7d401cab3"

  def install
    system "./configure", "--target=i386-elf",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}/i386-elf-binutils"
    system "make"
    system "make", "install"

    # localization files may conflict with native tools
    (share/"locale").rmtree
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/i386-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{Formula["i386-elf-binutils"].bin}/i386-elf-objdump -a test-s.o")
  end
end
