-- Redis script to get the size of a token bucket
-- see https://medium.com/callr-techblog/rate-limiting-for-distributed-systems-with-redis-and-lua-eeea745cb260
-- (c) Florent CHAUVEAU <florent.chauveau@gmail.com>

local ts  = tonumber(ARGV[1])
local key = KEYS[1]

-- remove tokens < min (older than now() -1s)
local min = ts -1

redis.call('ZREMRANGEBYSCORE', key, '-inf', min)
return redis.call('ZCARD', key)
