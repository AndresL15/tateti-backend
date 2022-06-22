class Game < ApplicationRecord
    validates :name, uniqueness: true
    before_validation(on: :create) do
        self.state = "012345678"
        self.current_symbol = "X"
    end 
end
