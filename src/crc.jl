mutable struct CRCChecksum{P<:Unsigned, F<:Function} <: AbstractChecksum{P}
    handler::F
    bytes::Int
end

function CRCChecksum(spec::CRC.Spec{P}) where {P<:Unsigned}
    handler = crc(spec)
    CRCChecksum{P, typeof(handler)}(handler, 0)
end

CRC32Checksum() = CRCChecksum(CRC.CRC_32)

function update!(cs::CRCChecksum, data::AbstractVector{UInt8})
    cs.handler(data; append=true)
    cs.bytes += length(data)
    return cs
end

# CRC library does not have a CodeUnits consumer
function update!(cs::CRCChecksum, data::Base.CodeUnits)
    v = unsafe_wrap(Vector{UInt8}, pointer(data), length(data))
    cs.handler(v; append=true)
    cs.bytes += length(v)
    return cs
end

function update!(cs::CRCChecksum, data::UInt8)
    cs.handler([data]; append=true)
    cs.bytes += 1
    return cs
end

function checksum(cs::CRCChecksum)
    return cs.handler(UInt8[]; append=true)
end

bytes_processed(cs::CRCChecksum) = Int(cs.bytes)

function reset!(cs::CRCChecksum)
    cs.handler(UInt8[])
    cs.bytes = 0
    cs
end

CRCChecksumStream(spec::CRC.Spec, io::IO) = ChecksumStream(CRCChecksum(spec), io)

CRC32ChecksumStream(io::IO) = CRCChecksumStream(CRC.CRC_32, io)