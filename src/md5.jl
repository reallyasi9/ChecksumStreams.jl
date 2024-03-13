mutable struct MD5Checksum <: AbstractChecksum{Vector{UInt8}}
    state::MD5.MD5_CTX
end

MD5Checksum() = MD5Checksum(MD5.MD5_CTX())

function update!(cs::MD5Checksum, data::AbstractVector{UInt8})
    update!(cs.state, data)
    return cs
end

function update!(cs::MD5Checksum, data::UInt8)
    update!(cs.state, data)
    return cs
end

function checksum(cs::MD5Checksum)
    s = deepcopy(cs.state)
    return digest!(s)
end

bytes_processed(cs::MD5Checksum) = Int(cs.state.bytecount)

function reset!(cs::MD5Checksum)
    cs.state = MD5.MD5_CTX()
    cs
end

MD5ChecksumStream(io::IO) = ChecksumStream(MD5Checksum(), io)