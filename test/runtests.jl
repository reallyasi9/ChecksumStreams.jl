using ChecksumStreams
using TestItemRunner

@testitem "Adler32Checksum" begin
    a32 = Adler32Checksum()
    @test checksum(a32) == 0x00000001
    @test bytes_processed(a32) == 0

    update!(a32, b"abcde")
    @test checksum(a32) == 0x05c801f0
    @test bytes_processed(a32) == 5

    update!(a32, b"f")
    @test checksum(a32) == 0x081e0256
    @test bytes_processed(a32) == 6

    reset!(a32)
    @test checksum(a32) == 0x00000001
    @test bytes_processed(a32) == 0
end

@testitem "Adler32ChecksumStream" begin
    a32 = Adler32Checksum()
    s = IOBuffer("abcdef")
    a32s = ChecksumStream(a32, s)
    @test checksum(a32s) == 0x00000001
    @test bytes_processed(a32s) == 0

    out = read(a32s, 5)
    @test out == b"abcde"
    @test checksum(a32s) == 0x05c801f0
    @test bytes_processed(a32s) == 5

    out = read(a32s, 1)
    @test out == b"f"
    @test checksum(a32s) == 0x081e0256
    @test bytes_processed(a32s) == 6

    reset!(a32)
    @test checksum(a32s) == 0x00000001
    @test bytes_processed(a32s) == 0

    s = IOBuffer()
    a32s = Adler32ChecksumStream(s)
    write(a32s, "abcde")
    @test checksum(a32s) == 0x05c801f0
    @test bytes_processed(a32s) == 5

    write(a32s, "f")
    @test checksum(a32s) == 0x081e0256
    @test bytes_processed(a32s) == 6
end

@testitem "CRC32Checksum" begin
    crc32 = CRC32Checksum()
    @test checksum(crc32) == 0x00000000
    @test bytes_processed(crc32) == 0

    update!(crc32, b"abcde")
    @test checksum(crc32) == 0x8587d865
    @test bytes_processed(crc32) == 5

    update!(crc32, b"f")
    @test checksum(crc32) == 0x4b8e39ef
    @test bytes_processed(crc32) == 6

    reset!(crc32)
    @test checksum(crc32) == 0x00000000
    @test bytes_processed(crc32) == 0
end

@testitem "CRC32ChecksumStream" begin
    crc32 = CRC32Checksum()
    s = IOBuffer("abcdef")
    crc32s = ChecksumStream(crc32, s)
    @test checksum(crc32s) == 0x00000000
    @test bytes_processed(crc32s) == 0

    out = read(crc32s, 5)
    @test out == b"abcde"
    @test checksum(crc32s) == 0x8587d865
    @test bytes_processed(crc32s) == 5

    out = read(crc32s, 1)
    @test out == b"f"
    @test checksum(crc32s) == 0x4b8e39ef
    @test bytes_processed(crc32s) == 6

    reset!(crc32)
    @test checksum(crc32s) == 0x00000000
    @test bytes_processed(crc32s) == 0

    s = IOBuffer()
    crc32s = CRC32ChecksumStream(s)
    write(crc32s, "abcde")
    @test checksum(crc32s) == 0x8587d865
    @test bytes_processed(crc32s) == 5

    write(crc32s, "f")
    @test checksum(crc32s) == 0x4b8e39ef
    @test bytes_processed(crc32s) == 6
end

@testitem "OtherCRCChecksum" begin

    crc = CRCChecksum(ChecksumStreams.CRC.CRC_32_C)
    @test checksum(crc) == 0x00000000
    @test bytes_processed(crc) == 0

    update!(crc, b"abcde")
    @test checksum(crc) == 0xc450d697
    @test bytes_processed(crc) == 5

    update!(crc, b"f")
    @test checksum(crc) == 0x53bceff1
    @test bytes_processed(crc) == 6

    reset!(crc)
    @test checksum(crc) == 0x00000000
    @test bytes_processed(crc) == 0
end

@testitem "OtherCRCChecksumStream" begin
    crc = CRCChecksum(ChecksumStreams.CRC.CRC_32_C)
    s = IOBuffer("abcdef")
    crcs = ChecksumStream(crc, s)
    @test checksum(crcs) == 0x00000000
    @test bytes_processed(crcs) == 0

    out = read(crcs, 5)
    @test out == b"abcde"
    @test checksum(crcs) == 0xc450d697
    @test bytes_processed(crcs) == 5

    out = read(crcs, 1)
    @test out == b"f"
    @test checksum(crcs) == 0x53bceff1
    @test bytes_processed(crcs) == 6

    reset!(crc)
    @test checksum(crcs) == 0x00000000
    @test bytes_processed(crcs) == 0

    s = IOBuffer()
    crcs = CRCChecksumStream(ChecksumStreams.CRC.CRC_32_C, s)
    write(crcs, "abcde")
    @test checksum(crcs) == 0xc450d697
    @test bytes_processed(crcs) == 5

    write(crcs, "f")
    @test checksum(crcs) == 0x53bceff1
    @test bytes_processed(crcs) == 6
end

@testitem "MD5Checksum" begin
    md5 = MD5Checksum()
    @test checksum(md5) == hex2bytes("d41d8cd98f00b204e9800998ecf8427e")
    @test bytes_processed(md5) == 0

    update!(md5, b"abcde")
    @test checksum(md5) == hex2bytes("ab56b4d92b40713acc5af89985d4b786")
    @test bytes_processed(md5) == 5

    update!(md5, b"f")
    @test checksum(md5) == hex2bytes("e80b5017098950fc58aad83c8c14978e")
    @test bytes_processed(md5) == 6

    reset!(md5)
    @test checksum(md5) == hex2bytes("d41d8cd98f00b204e9800998ecf8427e")
    @test bytes_processed(md5) == 0
end

@testitem "MD5ChecksumStream" begin
    md5 = MD5Checksum()
    s = IOBuffer("abcdef")
    md5s = ChecksumStream(md5, s)
    @test checksum(md5s) == hex2bytes("d41d8cd98f00b204e9800998ecf8427e")
    @test bytes_processed(md5s) == 0

    out = read(md5s, 5)
    @test out == b"abcde"
    @test checksum(md5s) == hex2bytes("ab56b4d92b40713acc5af89985d4b786")
    @test bytes_processed(md5s) == 5

    out = read(md5s, 1)
    @test out == b"f"
    @test checksum(md5s) == hex2bytes("e80b5017098950fc58aad83c8c14978e")
    @test bytes_processed(md5s) == 6

    reset!(md5)
    @test checksum(md5s) == hex2bytes("d41d8cd98f00b204e9800998ecf8427e")
    @test bytes_processed(md5s) == 0

    s = IOBuffer()
    md5s = MD5ChecksumStream(s)
    write(md5s, "abcde")
    @test checksum(md5s) == hex2bytes("ab56b4d92b40713acc5af89985d4b786")
    @test bytes_processed(md5s) == 5

    write(md5s, "f")
    @test checksum(md5s) == hex2bytes("e80b5017098950fc58aad83c8c14978e")
    @test bytes_processed(md5s) == 6
end

@testitem "SHA256Checksum" begin
    sha256 = SHA256Checksum()
    @test checksum(sha256) == hex2bytes("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    @test bytes_processed(sha256) == 0

    update!(sha256, b"abcde")
    @test checksum(sha256) == hex2bytes("36bbe50ed96841d10443bcb670d6554f0a34b761be67ec9c4a8ad2c0c44ca42c")
    @test bytes_processed(sha256) == 5

    update!(sha256, b"f")
    @test checksum(sha256) == hex2bytes("bef57ec7f53a6d40beb640a780a639c83bc29ac8a9816f1fc6c5c6dcd93c4721")
    @test bytes_processed(sha256) == 6

    reset!(sha256)
    @test checksum(sha256) == hex2bytes("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    @test bytes_processed(sha256) == 0
end

@testitem "SHA256ChecksumStream" begin
    sha256 = SHA256Checksum()
    s = IOBuffer("abcdef")
    sha256s = ChecksumStream(sha256, s)
    @test checksum(sha256s) == hex2bytes("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    @test bytes_processed(sha256s) == 0

    out = read(sha256s, 5)
    @test out == b"abcde"
    @test checksum(sha256s) == hex2bytes("36bbe50ed96841d10443bcb670d6554f0a34b761be67ec9c4a8ad2c0c44ca42c")
    @test bytes_processed(sha256s) == 5

    out = read(sha256s, 1)
    @test out == b"f"
    @test checksum(sha256s) == hex2bytes("bef57ec7f53a6d40beb640a780a639c83bc29ac8a9816f1fc6c5c6dcd93c4721")
    @test bytes_processed(sha256s) == 6

    reset!(sha256)
    @test checksum(sha256s) == hex2bytes("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    @test bytes_processed(sha256s) == 0

    s = IOBuffer()
    sha256s = SHA256ChecksumStream(s)
    write(sha256s, "abcde")
    @test checksum(sha256s) == hex2bytes("36bbe50ed96841d10443bcb670d6554f0a34b761be67ec9c4a8ad2c0c44ca42c")
    @test bytes_processed(sha256s) == 5

    write(sha256s, "f")
    @test checksum(sha256s) == hex2bytes("bef57ec7f53a6d40beb640a780a639c83bc29ac8a9816f1fc6c5c6dcd93c4721")
    @test bytes_processed(sha256s) == 6
end

@testitem "OtherSHAChecksum" begin

    sha = SHAChecksum(ChecksumStreams.SHA.SHA3_256_CTX)
    @test checksum(sha) == hex2bytes("a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a")
    @test bytes_processed(sha) == 0

    update!(sha, b"abcde")
    @test checksum(sha) == hex2bytes("d716ec61e18904a8f58679b71cb065d4d5db72e0e0c3f155a4feff7add0e58eb")
    @test bytes_processed(sha) == 5

    update!(sha, b"f")
    @test checksum(sha) == hex2bytes("59890c1d183aa279505750422e6384ccb1499c793872d6f31bb3bcaa4bc9f5a5")
    @test bytes_processed(sha) == 6

    reset!(sha)
    @test checksum(sha) == hex2bytes("a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a")
    @test bytes_processed(sha) == 0
end

@testitem "OtherSHAChecksumStream" begin
    sha = SHA3Checksum(512)
    s = IOBuffer("abcdef")
    shas = ChecksumStream(sha, s)
    @test checksum(shas) == hex2bytes("a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26")
    @test bytes_processed(shas) == 0

    out = read(shas, 5)
    @test out == b"abcde"
    @test checksum(shas) == hex2bytes("1d7c3aa6ee17da5f4aeb78be968aa38476dbee54842e1ae2856f4c9a5cd04d45dc75c2902182b07c130ed582d476995b502b8777ccf69f60574471600386639b")
    @test bytes_processed(shas) == 5

    out = read(shas, 1)
    @test out == b"f"
    @test checksum(shas) == hex2bytes("01309a45c57cd7faef9ee6bb95fed29e5e2e0312af12a95fffeee340e5e5948b4652d26ae4b75976a53cc1612141af6e24df36517a61f46a1a05f59cf667046a")
    @test bytes_processed(shas) == 6

    reset!(sha)
    @test checksum(shas) == hex2bytes("a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26")
    @test bytes_processed(shas) == 0

    s = IOBuffer()
    shas = SHA3ChecksumStream(512, s)
    write(shas, "abcde")
    @test checksum(shas) == hex2bytes("1d7c3aa6ee17da5f4aeb78be968aa38476dbee54842e1ae2856f4c9a5cd04d45dc75c2902182b07c130ed582d476995b502b8777ccf69f60574471600386639b")
    @test bytes_processed(shas) == 5

    write(shas, "f")
    @test checksum(shas) == hex2bytes("01309a45c57cd7faef9ee6bb95fed29e5e2e0312af12a95fffeee340e5e5948b4652d26ae4b75976a53cc1612141af6e24df36517a61f46a1a05f59cf667046a")
    @test bytes_processed(shas) == 6
end

@run_package_tests verbose=true