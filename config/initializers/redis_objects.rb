#Redis::Objects.redis = DataMapper.repository(:default).adapter.instance_variable_get(:@redis)
Redis::Objects.redis = Redis.new
$redis = Redis::Objects.redis
