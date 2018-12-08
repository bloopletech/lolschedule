class SyncedStdout
  MUTEX = Mutex.new

  def self.puts(*args)
    MUTEX.synchronize { $stdout.puts(*args) }
  end
end