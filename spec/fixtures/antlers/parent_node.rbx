# frozen_string_literal: true

module LowLoad
  class ParentNode
    def render
      <p><{ ChildNode }></p>
    end
  end
end
