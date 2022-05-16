package databaseLabOfHUST.JAVASQL;

import java.sql.*;
import java.util.Scanner;

public class Transfer {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/finance?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";
    /**
     * 转账操作
     *
     * @param connection 数据库连接对象
     * @param sourceCard 转出账号
     * @param destCard 转入账号
     * @param amount  转账金额
     * @return boolean
     *   true  - 转账成功
     *   false - 转账失败
     */
    public static boolean transferBalance(Connection connection,
                             String sourceCard,
                             String destCard, 
                             double amount) throws SQLException{
        connection.setAutoCommit(false);
        String selectSql = "SELECT * FROM bank_card WHERE b_number= ?;";
        ResultSet resultSet = null;
        PreparedStatement preparedStatement = connection.prepareStatement(selectSql);
        preparedStatement.setString(1, sourceCard);
        resultSet = preparedStatement.executeQuery();
        if(!resultSet.next()) return false;
        double a_b_balance = resultSet.getDouble("b_balance");
        String a_b_type = resultSet.getString("b_type");
        if (a_b_balance < amount || a_b_type.equals("信用卡"))
            return false;
        preparedStatement.setString(1, destCard);
        resultSet = preparedStatement.executeQuery();
        if(!resultSet.next()) return false;
        String b_b_type = resultSet.getString("b_type");
        double b_b_balance = resultSet.getDouble("b_balance");

        String updateSql = "UPDATE bank_card SET b_balance = ? WHERE b_number = ?;";
        preparedStatement = connection.prepareStatement(updateSql);
        preparedStatement.setDouble(1, a_b_balance-amount);
        preparedStatement.setString(2, sourceCard);
        preparedStatement.executeUpdate();
        if(b_b_type.equals("信用卡")){
            b_b_balance -= amount;
        }else{
            b_b_balance += amount;
        }
        preparedStatement.setDouble(1, b_b_balance);
        preparedStatement.setString(2, destCard);
        preparedStatement.executeUpdate();
        connection.commit();
        connection.setAutoCommit(true);
        return true;
    }

    // 不要修改main() 
    public static void main(String[] args) throws Exception {

        Scanner sc = new Scanner(System.in);
        Class.forName(JDBC_DRIVER);

        Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);

        while(sc.hasNext())
        {
            String input = sc.nextLine();
            if(input.equals(""))
                break;

            String[]commands = input.split(" ");
            if(commands.length ==0)
                break;
            String payerCard = commands[0];
            String  payeeCard = commands[1];
            double  amount = Double.parseDouble(commands[2]);
            if (transferBalance(connection, payerCard, payeeCard, amount)) {
              System.out.println("转账成功。" );
            } else {
              System.out.println("转账失败,请核对卡号，卡类型及卡余额!");
            }
        }
        sc.close();
    }

}
