class UsersTable
  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(email, username, password)
    insert_user_sql = <<-SQL
      INSERT INTO users (email, username, password)
      VALUES ('#{email}', '#{username}', '#{password}')
      RETURNING id
    SQL

    @database_connection.sql(insert_user_sql).first["id"]
  end

  def find(id)
    find_sql = <<-SQL
      SELECT * FROM users
      WHERE id = #{id}
    SQL

    @database_connection.sql(find_sql).first
  end

  def find_by(email, password)
    find_by_sql = <<-SQL
      SELECT * FROM users
      WHERE email = '#{email}'
      AND password = '#{password}'
    SQL

    @database_connection.sql(find_by_sql).first
  end

  def find_id_by_name(username)
    find_sql = <<-SQL
      SELECT id FROM users
      WHERE username = '#{username}'
    SQL

    @database_connection.sql(find_sql).first
  end

  def delete(id)
    @database_connection.sql("DELETE FROM users where id = #{id}")
  end

  def select_all
    select_sql = "select * from users"
    @database_connection.sql(select_sql)
  end

  def select_all_asc
    select_sql = "select * from users order by username asc"
    @database_connection.sql(select_sql)
  end

  def select_all_desc
    select_sql = "select * from users order by username desc"
    @database_connection.sql(select_sql)
  end

end