module ChecksumStreams

using SimpleChecksums
using MD5
using SHA
import SHA: update!
using CRC

export AbstractChecksum, ChecksumStream,
    Adler32Checksum, Adler32ChecksumStream,
    MD5Checksum, MD5ChecksumStream,
    SHAChecksum, SHAChecksumStream,
    SHA1Checksum, SHA1ChecksumStream,
    SHA224Checksum, SHA224ChecksumStream,
    SHA256Checksum, SHA256ChecksumStream,
    SHA284Checksum, SHA384ChecksumStream,
    SHA512Checksum, SHA512ChecksumStream,
    SHA2Checksum, SHA2ChecksumStream,
    SHA3Checksum, SHA3ChecksumStream,
    CRCChecksum, CRCChecksumStream,
    CRC32Checksum, CRC32ChecksumStream

export update!, checksum, bytes_processed, reset!

include("abstractchecksum.jl")
include("stream.jl")
include("adler.jl")
include("md5.jl")
include("sha.jl")
include("crc.jl")

end
