# Use the official Redis image as a parent image
FROM redis:latest

# (Optional) Copy custom redis.conf file into the container
COPY redis.conf /usr/local/etc/redis/redis.conf

# Command to run Redis server with custom config file (if you have one)
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
