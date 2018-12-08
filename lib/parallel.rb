class Parallel
  MAX_PARALLELISM = 4
  MUTEX = Mutex.new

  def initialize(items)
    @items = items
  end

  def perform(&block)
    @items.each_slice(MAX_PARALLELISM) do |batch|
      threads = batch.map do |item|
        Thread.new { block.call(item) }
      end

      threads.each { |thread| thread.join }
    end
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