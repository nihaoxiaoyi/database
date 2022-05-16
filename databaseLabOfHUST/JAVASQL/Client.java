package databaseLabOfHUST.JAVASQL;

import java.sql.*;


public class Client {
    public static void main(String[] args) {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        
        try {
            String URL = "jdbc:mysql://127.0.0.1:3306/finance?useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";  
            String USER = "root";
            String PASS = "123123";
            String SQL = "SELECT c_name,c_mail,c_phone FROM client WHERE c_mail IS NOT NULL;";
            Class.forName("com.mysql.cj.jdbc.Driver");      //注册驱动程序
            connection = DriverManager.getConnection(URL,USER,PASS);         //获取数据库连接
            statement = connection.createStatement();
            resultSet = statement.executeQuery(SQL);
            System.out.println("姓名\t邮箱\t\t\t\t电话");
            while (resultSet.next()) {  
                System.out.print(resultSet.getString("c_name")+"\t");
                System.out.print(resultSet.getString("c_mail")+"\t\t");  
                System.out.println(resultSet.getString("c_phone"));  
            }
 
         } catch (ClassNotFoundException e) {
            System.out.println("Sorry,can`t find the JDBC Driver!"); 
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (statement != null) {
                    statement.close();
                }

                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
}
