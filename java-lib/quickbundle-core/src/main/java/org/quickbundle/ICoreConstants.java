package org.quickbundle;

import java.util.HashMap;
import java.util.Map;

/**
 * 保存全局的一些常量
 * 
 * @author  
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public interface ICoreConstants {
     
    //系统级定义    
    public final static String[] DESC_CREATE_DATE = new String[]{"modify_date", "ts"};  //描述创建时间
    public final static String DESC_CREATE_IP = "modify_ip";  //描述创建IP
    public final static String DESC_CREATE_USER_ID = "modify_user_id";  //描述创建用户ID
    public final static String[] DESC_MODIFY_DATE = new String[]{"modify_date", "ts"};  //描述修改时间
    public final static String DESC_MODIFY_IP = "modify_ip";  //描述修改IP
    public final static String DESC_MODIFY_USER_ID = "modify_user_id";  //描述修改用户ID

    //数据库定义
	public final static String DATABASE_PRODUCT_NAME_MYSQL = "MySQL";
    public final static String DATABASE_PRODUCT_NAME_ORACLE = "Oracle";
	public final static String DATABASE_PRODUCT_NAME_DB2 = "DB2";
	public final static String DATABASE_PRODUCT_NAME_SQLServer = "Microsoft SQL Server";
	public final static String DATABASE_PRODUCT_NAME_H2 = "H2";
	public final static String DATABASE_PRODUCT_NAME_HSQL = "HSQL Database Engine";
	public final static Map<String, String> DATABASE_PRODUCT_MAP = new HashMap<String, String>() {
		{
			this.put("com.mysql.jdbc.Driver", DATABASE_PRODUCT_NAME_MYSQL);
			this.put("org.gjt.mm.mysql.Driver", DATABASE_PRODUCT_NAME_MYSQL);
			this.put("oracle.jdbc.driver.OracleDriver", DATABASE_PRODUCT_NAME_ORACLE);
			this.put("net.sourceforge.jtds.jdbc.Driver", DATABASE_PRODUCT_NAME_SQLServer);
			this.put("org.h2.Driver", DATABASE_PRODUCT_NAME_MYSQL);
		}
	};
	
	public final static String DEFAULT_DATA_SOURCE = "dataSource";
	 
    public final static String DESC_USABLE_STATUS = "usable_status";
    public final static String RM_YES = "1";  //是的定义
    public final static String RM_NO = "0";  //否的定义
    
    public final static String RM_PAGE_SIZE = "rm_page_size";
    public final static String RM_CURRENT_PAGE = "rm_current_page";
    public final static String RM_PAGE_VO = "RM_PAGE_VO";
    public final static String RM_ORDER_STR = "RM_ORDER_STR";
    
    public static final String RM_ACTION_URI = "RM_ACTION_URI";

    //Action返回值的key
    public final static String RM_AJAX_JSON = "rm_ajax_json";
    public final static String RM_AJAX_RECORD_SIZE = "rm_ajax_record_size";
    public final static String RM_AJAX_SPLIT_KEY = "$";
    
    //工作流参数
    public final static String INSERT_FORM_ID = "INSERT_FORM_ID";
    public final static String WF_FORM_ID = "wf_form_id";
}