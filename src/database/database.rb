require 'sqlite3'

$db = SQLite3::Database.new('src/database/database.db')

# Database control module
module Database
  def self.create_table_item
    sql = "CREATE TABLE IF NOT EXISTS item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(256) NOT NULL,
        desc VARCHAR(256),
        complete INTEGER DEFAULT 0,
        id_list INTEGER
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

    sql = "UPDATE #{table} SET  #{update}  where id=#{id}"
    $db.execute(sql)
  end

  def self.delete(table, args)
    id = args.delete(:id)
    sql = "DELETE FROM #{table} WHERE id=#{id}"
    $db.execute(sql)
  end
end
