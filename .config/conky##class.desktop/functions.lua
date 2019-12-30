function conky_foo()
    return 'foo'
end

function conky_read_num(file, scale)
    fd = io.open(file)
    num = tonumber(fd:read()) / scale
    fd:close()
    return string.format('%.0f', num)
end
