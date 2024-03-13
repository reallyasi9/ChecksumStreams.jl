mutable struct SHAChecksum{T<:SHA.SHA_CTX} <: AbstractChecksum{Vector{UInt8}}
    state::T
end

SHAChecksum(::Type{CTX}) where {CTX<:SHA.SHA_CTX} = SHAChecksum(CTX())

function update!(cs::SHAChecksum, data::AbstractVector{UInt8})
    update!(cs.state, data)
    return cs
end

function update!(cs::SHAChecksum, data::UInt8)
    update!(cs.state, data)
    return cs
end

function checksum(cs::SHAChecksum)
    s = deepcopy(cs.state)
    return digest!(s)
end

bytes_processed(cs::SHAChecksum) = Int(cs.state.bytecount)

function reset!(cs::SHAChecksum{T}) where {T}
    cs.state = T()
    cs
end

SHAChecksumStream(::Type{CTX}, io::IO) where {CTX<:SHA.SHA_CTX} = ChecksumStream(SHAChecksum(CTX()), io)
