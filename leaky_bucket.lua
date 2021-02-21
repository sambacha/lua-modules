-- Redis script to implement a leaky bucket
-- see https://medium.com/callr-techblog/rate-limiting-for-distributed-systems-with-redis-and-lua-eeea745cb260
-- (c) Florent CHAUVEAU <florent.chauveau@gmail.com>

local ts  = tonumber(ARGV[1])
local cps = tonumber(ARGV[2])
local key = KEYS[1]

-- remove tokens < min (older than now() -1s)
local min = ts -1
redis.call('ZREMRANGEBYSCORE', key, '-inf', min)

local last = redis.call('ZRANGE', key, -1, -1)

local next = ts

if type(last) == 'table' and #last > 0 then
  for key,value in pairs(last) do
    next = tonumber(value) + 1/cps
    break -- break at first item
  end
end

if ts > next then
  -- the current ts is > than last+1/cps
  -- we'll keep ts
  next = ts
end

redis.call('ZADD', key, next, next)

return tostring(next - ts)
