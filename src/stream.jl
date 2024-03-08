struct ChecksumStream{C<:AbstractChecksum, T<:IO} <: IO
    cs::C
    io::T
end

Base.position(stream::ChecksumStream) = position(stream.io)
Base.seek(stream::ChecksumStream, pos::Integer) = seek(stream.io, pos)
Base.seekstart(stream::ChecksumStream) = seekstart(stream.io)
Base.seekend(stream::ChecksumStream) = seekend(stream.io)
Base.eof(stream::ChecksumStream) = eof(stream.io)
Base.isopen(stream::ChecksumStream) = isopen(stream.io)
Base.flush(stream::ChecksumStream) = flush(stream.io)
Base.close(stream::ChecksumStream) = close(stream.io)
Base.mark(stream::ChecksumStream) = mark(stream.io)
Base.unmark(stream::ChecksumStream) = unmark(stream.io)
Base.reset(stream::ChecksumStream) = reset(stream.io)
Base.ismarked(stream::ChecksumStream) = ismarked(stream.io)

function Base.unsafe_read(stream::ChecksumStream, output::Ptr{UInt8}, nbytes::UInt)
    unsafe_read(stream.io, output, nbytes)
    v = unsafe_wrap(Vector{UInt8}, output, nbytes)
    update!(stream.cs, v)
    return nothing
end

function Base.unsafe_write(stream::ChecksumStream, input::Ptr{UInt8}, nbytes::UInt)
    nb = unsafe_write(stream.io, input, nbytes)
    v = unsafe_wrap(Vector{UInt8}, input, nb)
    update!(stream.cs, v)
    return nb
end

function Base.read(stream::ChecksumStream, n::Integer = typemax(Int); kwargs...)
    v = read(stream.io, n; kwargs...)
    update!(stream.cs, v)
    return v
end

checksum(stream::ChecksumStream) = checksum(stream.cs)
bytes_processed(stream::ChecksumStream) = bytes_processed(stream.cs)