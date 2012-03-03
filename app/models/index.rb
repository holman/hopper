module Hopper
  # Used to queue up and manage pending probe jobs for a particular Project.
  #
  # Redis Keys:
  #
  #   hopper:index:all     - A List of completed indexed Projects.
  #   hopper:index:pending - A List of pending Projects.
  class Index
    def self.key
      "#{Hopper.redis_namespace}:index"
    end

    # All of the completed Projects.
    #
    # Returns an Array.
    def self.all
      $redis.lrange "#{key}:all", 0, -1
    end

    # All of the pending Projects.
    #
    # Returns an Array, with the first element being next to index.
    def self.pending
      $redis.lrange "#{key}:pending", 0, -1
    end

    # Queues up a new Source to look at.
    #
    # url - A String URL.
    #
    # Returns the current queue.
    def self.queue(url)
      $redis.rpush "#{key}:pending", url
    end

    # Adds a URL to the main index.
    #
    # url - A String URL.
    #
    # Returns the current queue.
    def self.add(url)
      $redis.rpush "#{key}:all", url
    end

    # The next element in the pending list.
    #
    # Returns a String URL.
    def self.next
      $redis.lpop "#{key}:pending"
    end
  end
end