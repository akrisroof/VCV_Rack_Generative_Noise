RANDOM_OUTPUT = 7


setDisplayMode("log")
log(debug.getinfo(1).source)
log("===========================")
log("Output " .. RANDOM_OUTPUT .. ": Random Walk")

TOTAL_LEN = 2500

buffer = {}
mean = 0
for i = 0, TOTAL_LEN do
    local current = math.random()-0.5
    buffer[i] = current
    mean = mean + current
end

res_buffer = {}
res_buffer_mean = 0
for i = 0, TOTAL_LEN do
    res_buffer[i] = 0
end

count = 0
function process(sampleRate, sampleTime)
    shift = 0.5
    count = (count + 1)%TOTAL_LEN
    mean = mean - buffer[count]
    if res_buffer_mean/TOTAL_LEN*100 > 5 then
        shift = 0.55
    end
    if res_buffer_mean/TOTAL_LEN*100 < 0 then
        shift = 0.45
    end
    local current = math.random()-shift
    mean = mean + current
    buffer[count] = current

    res_buffer_mean = res_buffer_mean - res_buffer[count]
    res_buffer_mean = res_buffer_mean + mean/TOTAL_LEN

    if isOutputConnected(RANDOM_OUTPUT) then
        setVoltage(RANDOM_OUTPUT, res_buffer_mean/TOTAL_LEN*100)
    end
end
