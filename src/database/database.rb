require 'sqlite3'

$db = SQLite3::Database.new('src/database/database.db')
$db.execute('PRAGMA foreign_keys = ON;')

# Database control module
module Database
  def self.create_table_item
    sql = "CREATE TABLE IF NOT EXISTS item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(256) NOT NULL,
        desc VARCHAR(256),
        id_list INTEGER,
        complete INTEGER DEFAULT 0,
        CONSTRAINT fk_IdList FOREIGN KEY (id_list) REFERENCES list (id) ON DELETE CASCADE
     );"
    $db.execute(sql)
  end

  def self.create_table_list
    sql = "CREATE TABLE IF NOT EXISTS list(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(256) NOT NULL
      );"
    $db.execute(sql)
  end

  def self.insert(table, args)
    attrs = args.keys
    symbols = [['?'] * attrs.size].join(', ')
    sql = "INSERT INTO #{table} (#{attrs.join(', ')}) VALUES (#{symbols})"
    $db.execute(sql, args.values)
  end

  def self.update(table, args)
    id = args.delete(:id)

    update = args.map do |key, val|
      if val.nil?
        "#{key}=''"
      else
        "#{key}=#{val}"
      end
    end.join(', ')

    sql = "UPDATE #{table} SET #{update} where id=#{id}"
    $db.execute(sql)
  end

  def self.delete(table, args)
    id = args.delete(:id)
    sql = "DELETE FROM #{table} WHERE id=#{id}"
    puts sql
    $db.execute(sql)
  end

  def self.select_all(table)
    $db.execute("SELECT * FROM #{table}")
  end

  def self.select_item_list(id_list)
    $db.execute("SELECT l.title, i.id, i.title, i.desc, i.complete as 'done' FROM list l join item i on i.id_list=l.id where l.id=#{id_list}")
  end
end
