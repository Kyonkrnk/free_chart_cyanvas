# frozen_string_literal: true
class Like < ApplicationRecord
  belongs_to :chart
  belongs_to :user
end
