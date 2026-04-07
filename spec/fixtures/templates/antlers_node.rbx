# frozen_string_literal: true

require 'low_node'

# A mock of a LowNode with RBX/Antlers syntax.
# We're currently using the real LowNode... maybe when that API settles down we will create a full mock this side.
class AntlersNode < LowNode
  def render(event:)
    <p>{"I'm a child"}</p>
  end
end
