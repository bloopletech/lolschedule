class Parallel
  MUTEX = Mutex.new

  def initialize(items)
    @items = items
  end

  def perform(&block)
    threads = @items.map do |item|
      Thread.new do
        block.call(item)
      end
    end

    threads.each { |thread| thread.join }
  end

  def perform_collate(&block)
    results = {}

    perform do |item|
      result = block.call(item)
      MUTEX.synchronize { results[item] = result }
    end

    results
  end
end