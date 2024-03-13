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
    CRCChecksum, CRCChecksumStream

export update!, checksum, bytes_processed, reset!

include("abstractchecksum.jl")
include("stream.jl")
include("adler.jl")
include("md5.jl")
include("sha.jl")
include("crc.jl")

end
