class ArrayStore
  attr_reader :storage
  def initialize
    @storage = []
  end
  
  alias_method :format_for_search, :storage
  def create(data = {})
    @storage.push data
  end 
  def find(data = {})
    storage.select do |e| 
      (e.to_a & data.to_a) == data.to_a
    end
  end
  def update(id, new_data = {})
    @storage.each_with_index do |e, i| 
      @storage[i] = new_data if e[:id] == id 
    end
  end
  
  def delete(data = {})
    @storage.length.times do
      @storage.each_with_index { |e, i| @storage.delete_at(i) if e == data }
    end
  end
end
class HashStore
  attr_reader :storage
  def initialize
    @storage = {}
  end
  
  def format_for_search
    res = []
    @storage.each { |_, v| res << v }
    res
  end
  def create(data = {})
    @storage[data[:id]] = data
  end 
  def find(data = {})
    res = []
    @storage.each { |_, v| res << v if (v.to_a & data.to_a) == data.to_a }
    res   
  end
 
  def update(id, new_data = {})
    @storage.each { |k, _| @storage[k] = new_data if k == id }
  end
  def delete(data = {})
    @storage.length.times do
      @storage.each { |k, v| @storage.delete(k) if v == data }
    end
  end
end
module ClassMethods
  def attributes(*att)
    if !@attributes_array
      @attributes_array = att
      att.each do |var|     
        work_with_attribute(var)
      end
    else
      @attributes_array
    end
  end   
  
  def work_with_attribute(var)
    attr_accessor var
    define_singleton_method "find_by_#{var}" do |arg|
      where({"#{var}": arg})
    end
  end
  def data_store(*data)
    if !@store
      @store = data[0]
    else
      @store
    end
  end
  def where(** attributes2)
    attributes2.each do |name, _|
      raise UnknownAttributeError unless @attributes_array.include?(name)
    end
    seek = attributes2.to_a
    @store.format_for_search.select do |e| 
      (e.to_a & seek) == seek
    end.map { |k| self.new(k.to_hash) }
  end
end
class DataModel
 
  class DeleteUnsavedRecordError < StandardError
  end
  class UnknownAttributeError < StandardError
  end
  attr_accessor :attributes_array, :store, :id
  extend ClassMethods
  def initialize(**attributes2)  
    @id = nil 
    self.class.attributes.each { |e| send "#{e}=", nil }   
    attributes2.each do |name, value|
      send "#{name}=", value if self.class.attributes.include?(name)
    end
  end
  def ==(other)
    bool_one = self.class == other.class && id == other.id && id != nil
    bool_two = equal?other
    bool_one || bool_two
  end
  def delete
    raise DeleteUnsavedRecordError if self.class.data_store.find(to_hash).empty?
    self.class.data_store.delete(to_hash)
    @id = nil
  end
  def save
    if @id
      self.class.data_store.update(@id, to_hash)  
    else
      free_id = 0
      self.class.data_store.format_for_search.each do |e| 
        free_id = e[:id] if e[:id] > free_id
      end    
      @id = free_id + 1
      self.class.data_store.create(to_hash)
    end
  end 
  
  def to_hash
    values = []  
    (self.class.attributes << :id).each_with_index do |name, i|
      values[i] = []
      values[i] << name
      values[i].push send name.to_s
    end   
    values = values.to_h
  end 
end