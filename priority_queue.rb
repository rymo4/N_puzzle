# Naive implementation using Hash#min
class PriorityQueue
  def initialize
    @storage = Hash.new { |hash, key| hash[key] = [] }
  end
  def insert(priority, data)
    @storage[priority] << data
  end
  def min
    return nil if @storage.empty?
    key, val = *@storage.min
    result = val.shift
    @storage.delete(key) if val.empty?
    result
  end
  def include? d
    @storage.values.flatten.include? d
  end
  def empty?
    @storage.empty?
  end
  def size
    @storage.size
  end
end
