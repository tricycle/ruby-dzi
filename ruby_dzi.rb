# Ruby Dzi generator
# A fork from Deep Zoom Slicer project
#
# Ruby Dzi slices images and generates a dzi file that is compatible with DeepZoom or Seadragon
#
# Requirements: rmagick gem (tested with version 2.9.0)
#
# Contributor: Marc Vitalis <marc.vitalis@live.com>
#
# Original Author:: MESO Web Scapes (www.meso.net)
# By:: Sascha Hanssen <hanssen@meso.net>
# License:: MPL 1.1/GPL 3/LGPL 3
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
# for the specific language governing rights and limitations under the
# License.
#
require File.join(File.dirname(__FILE__), 'lib', 'ruby_dzi', "base")
%w[file s3].each do |store|
  require File.join(File.dirname(__FILE__), 'lib', 'ruby_dzi', "#{store}_store")
end
