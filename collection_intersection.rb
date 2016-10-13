class CollectionsIntersection
  def initialize
    @collection = {}
  end

  def assoc(conv, intersected)
    @collection[intersected] ||= conv
  end

  def save
    fail(NotImplementedError)
  end

  def keys
    @collection.keys
  end
end
