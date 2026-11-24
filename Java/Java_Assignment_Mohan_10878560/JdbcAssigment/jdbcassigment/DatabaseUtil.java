package jdbcassigment;

import java.sql.Connection;
import java.sql.DriverManager;

/**
* @user:  10878560
*  @time:  4:19:23 pm
*  @date:  21 Nov 2026
*  @todo:  TODO
*
*
**/
public class DatabaseUtil {
	public static Connection createConnection() throws Exception
    {
        //Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/employeeassignment_db","root","root");
        return con;
    }
}
