-- Redis script to add an event to a token bucket
-- see https://medium.com/callr-techblog/rate-limiting-for-distributed-systems-with-redis-and-lua-eeea745cb260
-- (c) Florent CHAUVEAU <florent.chauveau@gmail.com>

local ts = tonumber(ARGV[1])

-- set the token bucket to 1 second (rolling)
local min = ts -1

-- iterate overs keys
for i,key in pairs(KEYS) do
    -- remove tokens < min
    redis.call('ZREMRANGEBYSCORE', key, '-inf', min)

    -- add a new token (ts)
    redis.call('ZADD', key, ts, ts)

    -- make the key expire in 10s
    redis.call('EXPIRE', key, 10)
end