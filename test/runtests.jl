using ChecksumStreams
using Test

@testset "ChecksumStreams.jl" begin
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
    a32s = ChecksumStream(a32, s)
    write(a32s, "abcde")
    @test checksum(a32s) == 0x05c801f0
    @test bytes_processed(a32s) == 5

    write(a32s, "f")
    @test checksum(a32s) == 0x081e0256
    @test bytes_processed(a32s) == 6

end
