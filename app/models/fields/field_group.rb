# Fat Free CRM
# Copyright (C) 2008-2011 by Michael Dvorkin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

# == Schema Information
#
# Table name: field_groups
#
#  id         :integer         not null, primary key
#  name       :string(64)
#  label      :string(128)
#  position   :integer
#  hint       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  tag_id     :integer
#  klass_name :string(32)
#

class FieldGroup < ActiveRecord::Base
  has_many :fields, :order => :position
  belongs_to :tag, :class_name => 'ActsAsTaggableOn::Tag'

  validates_presence_of :label

  before_save do
    self.name = label.downcase.gsub(/[^a-z0-9]+/, '_') if name.blank? and label.present?
  end

  def key
    "field_group_#{id}"
  end

  def klass
    klass_name.constantize
  end

  def core_fields
    fields.where(:type => 'CoreField')
  end

  def custom_fields
    fields.where(:type => 'CustomField')
  end

  def self.with_tags(tag_ids)
    where 'tag_id IS NULL OR tag_id IN (?)', tag_ids
  end

  def label_i18n
    I18n.t(name, :default => label)
  end
end
