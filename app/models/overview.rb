class Overview < ApplicationRecord
  def self.update_last_overview
     Overview.update(last_overview: DateTime.now)
   end

   def self.last_overview?
     Overview.select(:last_overview)
   end
end
