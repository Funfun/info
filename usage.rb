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
  Message.new(11, 12, 2, 4),  # new (sent)     # skipped

  Message.new(11, 12, 3, 1),  # reply (inbox)
  Message.new(12, 11, 4, 4),  # reply (sent)   # skipped

  Message.new(11, 12, 5, 3),  # archived
  Message.new(12, 11, 6, 4)   # new (sent)     # skipped
]

messages.each do |message|
  next if message.mail_box_id == 4
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
    intersection.assoc(conv, intersected)
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
