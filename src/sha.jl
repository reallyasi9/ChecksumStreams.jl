mutable struct SHAChecksum{T<:SHA.SHA_CTX} <: AbstractChecksum{Vector{UInt8}}
    state::T
end

SHAChecksum(::Type{CTX}) where {CTX<:SHA.SHA_CTX} = SHAChecksum(CTX())

SHA1Checksum() = SHAChecksum(SHA.SHA1_CTX)
SHA224Checksum() = SHAChecksum(SHA.SHA224_CTX)
SHA256Checksum() = SHAChecksum(SHA.SHA256_CTX)
SHA384Checksum() = SHAChecksum(SHA.SHA384_CTX)
SHA512Checksum() = SHAChecksum(SHA.SHA256_CTX)
function SHA2Checksum(bits::Integer)
    bits == 224 && return SHAChecksum(SHA.SHA2_224_CTX)
    bits == 256 && return SHAChecksum(SHA.SHA2_256_CTX)
    bits == 384 && return SHAChecksum(SHA.SHA2_384_CTX)
    bits == 512 && return SHAChecksum(SHA.SHA2_512_CTX)
    throw(ArgumentError("SHA2 context cannot be created with $bits bits"))
end
function SHA3Checksum(bits::Integer)
    bits == 224 && return SHAChecksum(SHA.SHA3_224_CTX)
    bits == 256 && return SHAChecksum(SHA.SHA3_256_CTX)
    bits == 384 && return SHAChecksum(SHA.SHA3_384_CTX)
    bits == 512 && return SHAChecksum(SHA.SHA3_512_CTX)
    throw(ArgumentError("SHA3 context cannot be created with $bits bits"))
end

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

SHA1ChecksumStream(io::IO) = SHAChecksumStream(SHA.SHA1_CTX, io)
SHA224ChecksumStream(io::IO) = SHAChecksumStream(SHA.SHA224_CTX, io)
SHA256ChecksumStream(io::IO) = SHAChecksumStream(SHA.SHA256_CTX, io)
SHA384ChecksumStream(io::IO) = SHAChecksumStream(SHA.SHA384_CTX, io)
SHA512ChecksumStream(io::IO) = SHAChecksumStream(SHA.SHA512_CTX, io)
function SHA2ChecksumStream(bits::Integer, io::IO)
    bits == 224 && return SHAChecksumStream(SHA.SHA2_224_CTX, io)
    bits == 256 && return SHAChecksumStream(SHA.SHA2_256_CTX, io)
    bits == 384 && return SHAChecksumStream(SHA.SHA2_384_CTX, io)
    bits == 512 && return SHAChecksumStream(SHA.SHA2_512_CTX, io)
    throw(ArgumentError("SHA2 context cannot be created with $bits bits"))
end
function SHA3ChecksumStream(bits::Integer, io::IO) 
    bits == 224 && return SHAChecksumStream(SHA.SHA3_224_CTX, io)
    bits == 256 && return SHAChecksumStream(SHA.SHA3_256_CTX, io)
    bits == 384 && return SHAChecksumStream(SHA.SHA3_384_CTX, io)
    bits == 512 && return SHAChecksumStream(SHA.SHA3_512_CTX, io)
    throw(ArgumentError("SHA3 context cannot be created with $bits bits"))
end