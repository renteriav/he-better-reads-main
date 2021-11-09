module Calculations
    def self.calculate_average(parent, children, attribute)
        children = parent.send(children)
        sum = children.sum(attribute.to_sym).to_f
        sum/(children.size).round(1)
    end
end