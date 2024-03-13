mutable struct CRCChecksum{P<:Unsigned, F<:Function} <: AbstractChecksum{P}
    handler::F
    bytes::Int
end

function CRCChecksum(spec::CRC.Spec{P}) where {P<:Unsigned}
    handler = crc(spec)
    CRCChecksum{P, typeof(handler)}(handler, 0)
end

function update!(cs::CRCChecksum, data::AbstractVector{UInt8})
    cs.handler(data; append=true)
    cs.bytes += length(data)
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
