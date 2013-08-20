package org.quickbundle.project.init;

import java.io.File;

public final class RmConfig {
	
	public enum PageKey {
		RM_PAGE_SIZE("rm_page_size"),
		RM_CURRENT_PAGE("rm_current_page"),
		RM_PAGE_VO("RM_PAGE_VO"),
		RM_ORDER_STR("RM_ORDER_STR");
		private String key;
		PageKey(String key_) {
			this.key = key_;
		}
		public String key() {
			return key;
		}
	}
	
	/**
	 * 配置类的全局唯一单例
	 */
	private static RmConfigVo singleton = new RmConfigVo();
	
	/**
	 * 得到配置类的全局唯一单例
	 * @return the singleton
	 */
	public static RmConfigVo getSingleton() {
		return singleton;
	}
	
	//定制static方法，处理单例的配置
	/**
	 * @return 是集群模式？或单机？
	 */
	public static boolean isClusterMode() {
		return singleton.isClusterMode();
	}
	/**
	 * @return 云节点信息是自动采集？还是从rm.xml中读取
	 */
	public static boolean isCloudNodeInfoAuto() {
		return singleton.isCloudNodeInfoAuto();
	}
    /**
     * 获得默认数据源的数据库类型
     * IGlobalConstants.DATABASE_PRODUCT_NAME_...
     * @return
     */
    public static String getDatabaseProductName() {
		return singleton.getDatabaseProductName();
	}
    /**
     * 是否水平拆分数据库
     * @return
     */
    public static boolean isMultiDb() {
        return singleton.isMultiDb();
    }
    
	/**
	 * 系统是否开发调试状态(系统综合运行性能较低，优化了应用启动速度。同时sql的?替换输出，日志记录了sql真实数据)
	 */
	public static boolean systemDebugMode() {
		 return singleton.isSystemDebugMode();
	}
	
	/**
	 * 本集群节点RmIdFactory产生的主键前缀
	 */
	public static String getClusterIdPrefix() {
		return singleton.getClusterIdPrefix();
	}
	
	/**
	 * 是否RmIdFactory每次从数据库中读取，生成id (用于多人clusterIdPrefix相同，而且要同时开发)
	 */
	public static boolean isGenerateIdFromDb() {
		return singleton.isGenerateIdFromDb();
	}
	
	/**
	 * 系统用户是否唯一登录，同时登录会强制踢出第一个用户
	 */
	public static boolean userUniqueLogin() {
		return singleton.isUserUniqueLogin();
	}
	
	/**
	 * 默认的分页条数，会被rm.xml/rm/RmJspHelper/pageSize覆盖
	 */
	public static int defaultPageSize() {
		return singleton.getDefaultPageSize();
	}
	
	/**
	 * 是否启动任务调度
	 */
	public static boolean isSchedulerStart() {
		return singleton.isSchedulerStart();
	}
	
	/**
	 * 得到系统简短描述
	 * @return
	 */
	public static String getAppDescription() {
		return singleton.getAppDescription();
	}
	
	/**
	 * 是否记录request的执行时间和SQL数量
	 * @return the logRequest
	 */
	public static boolean isLogRequest() {
		return singleton.isLogRequest();
	}
	
	
	//未加入rm.xml文件的配置
	
	/**
	 * 系统缓存检查周期
	 * @return
	 */
	public static long cacheCheckInterval() {
		return 1000 * 2;
	}
	
	/**
	 * 是否全局监控
	 * @return
	 */
	public static boolean globalMonitor() {
		return true;
	}
	
	/**
	 * 系统缓存刷新周期
	 * @return
	 */
	public static long cacheFlushInterval() {
		return 1000 * 60 * 5;
	}
	
    /**
     * 翻页是否用rs.absolute(index)的方案
     */
    public static boolean isAbsolutePage() {
    	return false;
    }
    
    /**
     * 批处理sql的最大记录日志数量
     */
    public static int maxLogSqlBatchSize() {
    	return 100;
    }
	
	/**
	 * 系统用户登录是否DEMO状态(不校验用户数据库)
	 */
	public static boolean userDemoMode() {
		return false;
	}
	
	/**
	 * 是否给insert和update的sql语句自动加ts
	 */
	public static boolean sqlUpdateAutoAppendTs() {
		return false;
	}
	
	/**
	 * 默认的临时文件夹
	 */
	public static File defaultTempDir() {
		return new File(System.getProperty("java.io.tmpdir") + File.separator + "rm");
	}
	
	/**
	 * 默认编码
	 */
	public static String defaultEncode() {
		return "UTF-8";
	}
	
	/**
	 * 默认实数数值的精度
	 */
	public static int defaultNumberScale() {
		return 2;
	}
	
	/**
	 * 登录时是否有校验码
	 */
	public static boolean loginValidateVerifyCode() {
		return true;
	}
	
	/**
	 * 登录是持否支持cookie
	 */
	public static boolean loginCookie() {
		return true;
	}
	
	/**
	 * cookie默认值365天
	 */
	public static int defaultCookieAge() {
		return 365 * 24 * 60 * 60;
	}
		
	/**
	 * ajax提交是否已json格式，还是post表单提交？
	 */
	public static boolean isSubmitJson() {
		return false;
	}
	
	/**
	 * 默认的树形编码起始值，适用于简单的纯数字树，每个节点下最多有900个子节点
	 */
	public static String defaultTreeCodeFirst() {
		return "100";
	}
    
	/**
	 * 指定最大循环次数，防止死循环
	 */
	public static int maxCircleCount() {
		return 10000;
	}
	
	/**
	 * 定义单实例全局缓存的最大容量，防止溢出攻击，如公开的url列表
	 * @return
	 */
	public static int maxCacheSize() {
		return 10000;
	}
}