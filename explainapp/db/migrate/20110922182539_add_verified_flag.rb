#
#   Copyright [2011-2012] [Solr.pl, Marek Rogoziński, Rafał Kuć]
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
class AddVerifiedFlag < ActiveRecord::Migration
  def self.up
    add_column :explains, :verified, :boolean
    add_index :explains, :code
    Explain.update_all ['verified = ?', true]
  end

  def self.down
    remove_column :explains, :verified
    remove_index :explains, :code
  end
end
