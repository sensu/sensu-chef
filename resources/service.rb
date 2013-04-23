actions :enable, :disable

attribute :init_style, :kind_of => String, :required => true, :regex => /^(sysv|runit)$/

def initialize(*args)
  super
  @action = :enable
end
