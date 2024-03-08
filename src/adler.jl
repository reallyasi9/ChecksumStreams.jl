mutable struct Adler32Checksum <: AbstractChecksum{UInt32}
    sum::UInt32
    nb::Int
end

Adler32Checksum(init::Integer = UInt32(1)) = Adler32Checksum(UInt32(init), 0)

function update!(cs::Adler32Checksum, data::UInt8)
    cs.sum = adler32(data, cs.sum)
    cs.nb += 1
    return cs
end

function update!(cs::Adler32Checksum, data::AbstractVector{UInt8})
    cs.sum = adler32(data, cs.sum)
    cs.nb += length(data)
    return cs
end

checksum(cs::Adler32Checksum) = cs.sum

bytes_processed(cs::Adler32Checksum) = cs.nb

function reset!(cs::Adler32Checksum)
    cs.sum = UInt32(1)
    cs.nb = 0
    cs
end

Adler32ChecksumStream(io::IO, init::Integer = UInt32(1)) = ChecksumStream(Adler32Checksum(init), io)