# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
class NullMutex
  def lock
    # TODO: Should lock return nil or self?
    return nil
  end

  def locked?
    return false
  end

  def synchronize(*args)
    yield(*args)
  end

  def try_lock
    return true
  end

  def unlock
    return nil
  end
end
