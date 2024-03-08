module ChecksumStreams

using SimpleChecksums
using MD5
using SHA

export ChecksumStream
export AbstractChecksum, Adler32Checksum, Adler32ChecksumStream, MD5Checksum, MD5ChecksumStream

export update!, checksum, bytes_processed, reset!

include("abstractchecksum.jl")
include("stream.jl")
include("adler.jl")
include("md5.jl")

end
