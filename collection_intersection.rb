class CollectionsIntersection
  def initialize
    @collection = {}
  end

  def assoc(conv, intersected)
    @collection[intersected.key(p1, p2)] ||= conv.id
  end

  def save
    fail(NotImplementedError)
  end

  def keys
    @collection.keys
  end
end
