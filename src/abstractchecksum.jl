abstract type AbstractChecksum{T} end

"""
    update!(cs, data) -> cs
"""
update!

function update!(cs::AbstractChecksum, data::AbstractVector{UInt8})
    for val in data
        update!(cs, val)
    end
    return cs
end

function update!(cs::AbstractChecksum, io::IO)
    buffer = Vector{UInt8}(undef, 1<<20)
    nb = readbytes!(io, buffer)
    return update!(cs, @view(buffer[1:nb]))
end

"""
    checksum(cs::AbstractChecksum{T}) -> T
"""
checksum

"""
    bytes_processed(cs) -> Int
"""
bytes_processed

"""
    reset!(cs) -> cs
"""
reset!