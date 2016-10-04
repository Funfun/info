require 'digest/md5'

class ConversationCollection
  def initialize
    # Structure:
    #     key: "uuid"
    #   value: [messages#id, ...]
    @collection = {}
  end

  def find(party_one, party_two)
    @collection[key(party_one, party_two)]
  end

  # Return [messages#id, ...]
  def find_or_create_by(party_one, party_two)
    @collection[key(party_one, party_two)] ||= []
  end

  # Append message_id to collection by UUID.
  def add_message(party_one, party_two, message_id)
    conversation = find_or_create_by(party_one, party_two)
    conversation.push(message_id)
  end

  # Return uuid
  def key(a, b)
    Digest::MD5.hexdigest([a, b].sort.to_s)
  end

  def length
    @collection.keys.length
  end

  def to_s
    @collection.inspect
  end
end
