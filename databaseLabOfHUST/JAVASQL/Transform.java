package databaseLabOfHUST.JAVASQL;

import java.sql.*;

public class Transform {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/sparsedb?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";

    public static class Node {
        private String col_name;
        private int col_value;

        public void setValue(String col_name, int col_value) {
            this.col_name = col_name;
            this.col_value = col_value;
        }

        public int getCol_value() {
            return col_value;
        }

        public String getCol_name() {
            return col_name;
        }
    }

    /**
     * 向sc表中插入数据
     * 
     * @throws ClassNotFoundException
     * @throws SQLException
     *
     */
    public static int insertSC() throws ClassNotFoundException, SQLException {
        Class.forName(JDBC_DRIVER);
        Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);
        String sql = "SELECT * FROM entrance_exam;";
        String insertSql = "INSERT INTO sc VALUES(?,?,?);";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet resultSet = preparedStatement.executeQuery();
        Node node = new Node();
        String[] col_names = new String[] { "chinese", "math", "english", "physics", "chemistry", "biology", "history",
                "geography", "politics" };
        int index;
        final int col_length = 9;
        int counts = 0;
        preparedStatement = connection.prepareStatement(insertSql);
        while (resultSet.next()) {
            index = 0;
            preparedStatement.setInt(1, resultSet.getInt("sno"));
            while (index < col_length) {
                node.setValue(col_names[index], resultSet.getInt(col_names[index]));
                if (node.getCol_value() != 0) {
                    preparedStatement.setString(2, col_names[index]);
                    preparedStatement.setInt(3, node.getCol_value());
                    preparedStatement.executeUpdate();
                    counts++;
                }
                index++;
            }
        }
        return counts;
    }

    public static void main(String[] args) throws Exception {
        insertSC();
    }
}
