# frozen_string_literal: true

class Overview < ApplicationRecord
  def self.update_last_overview
    Overview.create!(last_overview: DateTime.now)
   end

  def self.last_overview?
    Overview.maximum(:last_overview)
  end
end
