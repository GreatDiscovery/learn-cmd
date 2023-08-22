# encoding: utf-8
import redis

conn = redis.Redis(host='10.212.130.209', port=6379, db=0)
count = 0

for key in conn.scan_iter(match='zset:p_g_a*', count=100000):
    count += 1

print(f"以 abc 开头的键值数量为 {count}")