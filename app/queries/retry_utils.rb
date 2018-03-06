module RetryUtils
  # Calls a block and retries if it fails
  def query_retry(i, &save_block)
    begin
      return save_block.call
    rescue # Retry a few times
      sleep(2*i+1)
      if i < 10
        i += 1
        query_retry(i, &save_block)
      else # Retried too many times
        binding.pry
      end
    end
  end
end
