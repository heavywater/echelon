
def initialize(*args)
  super
  @action = :create
end

actions :create, :delete

attribute :lines, :kind_of => Array, :required => false

%w(forecasts fields).each do |attr_hash|
  attribute attr_hash, :kind_of => Hash, :required => false
end

%w(dashboard_name dashboard_category).each do |attr_string_req|
  attribute attr_string_req, :kind_of => String, :required => true
end

hash_attrs = %w(warning critical)
hash_attrs.each do |attr_hash|
  attribute attr_hash, :kind_of => String, :required => false
end

string_attrs = %w(vtitle description major_grid_line_color minor_grid_line_color from until)
string_attrs.each do |attr_string|
  attribute attr_string, :kind_of => String, :required => false
end

int_attrs = %w(width height ymin ymax linewidth fontsize)
int_attrs.each do |attr_int|
  attribute attr_int, :kind_of => Fixnum, :required => false
end

bool_attrs = %w(hide_legend draw_null_as_zero fontbold hide_grid)
bool_attrs.each do |attr_bool|
  attribute attr_bool, :kind_of => [TrueClass, FalseClass], :required => false
end

attribute :area, :kind_of => [Symbol, String], :required => false
attribute :linemode, :kind_of => [Symbol, String], :required => false

unless(defined?(::GDASH_RESOURCE_ATTRIBS))
  ::GDASH_RESOURCE_ATTRIBS = string_attrs + int_attrs + bool_attrs + hash_attrs + %w(area linemode)
end
