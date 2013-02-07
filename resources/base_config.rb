actions :create

attribute :type, :kind_of => String, :equal_to => %w[server client]

def initialize(*args)
  super
  @action = :create
end
