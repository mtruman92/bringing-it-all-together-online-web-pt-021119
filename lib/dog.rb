class Dog 
  
  attr_accessor :name, :breed 
  attr_reader :id 
  
  def initialize(id:nil,name:,breed:)
    @id = id 
    @name = name 
    @breed = breed
  end 
  
  def self.create_table 
    sql = <<-SQL 
    CREATE TABLE dogs (
    name TEXT,
    breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end
  
   def self.drop_table 
    sql = <<-SQL 
    DROP TABLE dogs 
    SQL
    DB[:conn].execute(sql)
  end
  
  def save 
    sql = <<-SQL 
    INSERT INTO dogs (name, breed)
    VALUES (?,?)
    SQL
    
    DB[:conn].execute(sql,self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end
  
  def self.create(name:,breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save 
    dog
  end
  
  def self.find_by_id 
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Dog.new_from_db(result)
  end
end