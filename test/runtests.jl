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

@run_package_tests verbose=true