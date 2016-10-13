require './conversation_collection.rb'
require './collection_intersection.rb'
require 'rubygems'
require 'active_record'
require 'yaml'

Message = Struct.new(:from_id, :to_id, :id, :mail_box_id) do
end

conversations = ConversationCollection.new

# mocked example
messages = [
  Message.new(12, 11, 1, 1),  # new (inbox)
  Message.new(12, 11, 2, 4),  # new (sent)      # skipped by us

  Message.new(11, 12, 3, 1),  # reply (inbox)
  Message.new(11, 12, 4, 4),  # reply (sent)    # skipped by us

  Message.new(11, 12, 5, 3),  # archived (by 12)
  Message.new(11, 12, 6, 4),  # new (sent)      # skipped by us

  Message.new(12, 11, 7, 2),  # deleted (by 11) # skipped by us
  Message.new(12, 11, 8, 4)   # reply (sent)    # skipped by us
]

skip_ids = [2, 4].freeze
messages.each do |message|
  next if skip_ids.include?(message.mail_box_id)
  conversations.add_message(message.from_id, message.to_id, message.id)
end

# expected result:
# "uuid" => [1, 3, 5]
puts conversations.length
puts conversations.to_s
# next step:
# Save collection to db

intersection = CollectionsIntersection.new

config_file = ARGV.shift
exit if config_file.nil?
config = YAML.load_file(config_file)

ActiveRecord::Base.establish_connection(config)

class Conversation < ActiveRecord::Base; end

db_conversations = Conversation.all
db_conversations.each do |conv|
  p1 = conv.sender_id
  p2 = conv.recipient_id
  local_conversation = collection.find(p1, p2)
  if local_conversation
    intersection.assoc(conv.id, intersected.key(p1, p2))
  end
end
intersection.save

# Loop over Conversations
conversations.each do |conversation_key, conversation_messages|
  if intersection[conversation_key]
    # existing
  else
    # new conversation
  end
end
