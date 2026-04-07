# frozen_string_literal: true

require 'low_node'

class HTMLNode < LowNode
  def render
    <<~HTML
      <p>Hello</p>
    HTML
  end
end
