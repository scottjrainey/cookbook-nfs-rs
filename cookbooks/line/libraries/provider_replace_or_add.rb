#
# Cookbook Name:: line
# Library:: provider_replace_or_add
#
# Author:: Sean OMeara <someara@opscode.com>                                  
# Copyright 2012-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#    

class Chef
  class Provider
    class ReplaceOrAdd < Chef::Provider

      def load_current_resource
      end

      def action_edit
        f = Chef::Util::FileEdit.new(new_resource.path)
        Chef::Log.info("DEBUG: replace_or_add: new_resource.path #{new_resource.path}")
        g = f.dup

        # first, attempt to find and replace
        f.search_file_replace(new_resource.pattern,new_resource.line)
        f.write_file
        
        # hax CHEF-3714
        Chef::Log.info("DEBUG: replace_or_add: f.inspect.split('@')[3] #{f.inspect.split('@')[3]}")
        Chef::Log.info("DEBUG: replace_or_add: g.inspect.split('@')[3] #{g.inspect.split('@')[3]}")

        if f.inspect.split('@')[3] != g.inspect.split('@')[3] then
          Chef::Log.info "DEBUG : EDITED THAT SHIT!"
          new_resource.updated_by_last_action(true)
        else
          # if that didn't work, add it to the file.
          regex = escape_string new_resource.line
          regex = "^#{regex}$"
          
          f.insert_line_if_no_match(/#{regex}/,new_resource.line)
          f.write_file
          
          if f.inspect.split('@')[3] != g.inspect.split('@')[3] then
            Chef::Log.info "DEBUG : EDITED THAT SHIT!"
            new_resource.updated_by_last_action(true)
          end          
        end
        
      end
    end
  end
end

