package org.quickbundle.project.init;

public class RmConfigVo {
	
	private String warHome = "/qb_home/default";
	
	/**
	 * 		<!-- cloud node info collected automatically? or read from rm.xml? #change in production -->
		<cloudNodeInfoAuto>false</cloudNodeInfoAuto>
	 * @return 是集群模式？或单机？
	 */
	private boolean clusterMode = false;

	/**
	 * @return 云节点信息是自动采集？还是从rm.xml中读取
	 */
	private boolean cloudNodeInfoAuto = false;
    
    /**
     * 获得默认数据源的数据库类型，默认数据库类型是NULL
     * IGlobalConstants.DATABASE_PRODUCT_NAME_...
     */
	private String databaseProductName = null;
	
    /**
     * 是否水平拆分数据库，默认不拆分数据库
     */
    private boolean multiDb = false;
	
    /**
     * 系统是否开发调试状态(性能很低，便利于开发调试。同时sql的?替换输出，日志记录了sql真实数据)
     * 默认不是开发调试状态，是正式运行状态
     */
    private boolean systemDebugMode = true;
	
	/**
	 * 本集群节点RmIdFactory产生的主键前缀
	 */
	private String clusterIdPrefix = "1000";

	/**
	 * 是否RmIdFactory每次从数据库中读取，生成id (用于多人clusterIdPrefix相同，而且要同时开发)
	 */
	private boolean generateIdFromDb = false;
	
	/**
	 * RmIdFactory init id batch, union all?
	 */
	private boolean initIdBatch = false;

	public boolean isInitIdBatch() {
		return initIdBatch;
	}

	public void setInitIdBatch(boolean initIdBatch) {
		this.initIdBatch = initIdBatch;
	}

	/**
	 * 系统用户是否唯一登录，同时登录会强制踢出第一个用户
	 */
	private boolean userUniqueLogin = true;

	
	/**
	 * 默认的分页条数，默认按15条分页，会被rm.xml/rm/RmJspHelper/pageSize覆盖
	 */
	private int defaultPageSize = 15;
	
	/**
	 * 默认的批处理条数，用于sql的union all条数
	 */
	private int defaultBatchSize = 10;
	
	/**
	 * 是否启动任务调度
	 */
	private boolean schedulerStart = false;
	
	/**
	 * 得到系统描述
	 */
	private String appDescription = "QuickBundle System";
	
	/**
	 * 是否记录request的执行时间和SQL数量
	 */
	private boolean logRequest = true;
	
	/**
	 * Python的Lib目录不存在时，自动解压缩
	 */
	private boolean createPythonLibIfNotExist = true;

	/**
	 * Perl的目录不存在时，自动解压缩
	 */
	private boolean createPerlIfNotExist = true;
	
	/**
	 * 是否逻辑删除文件
	 */
	private boolean logicDeleteFile = false;
	
	/**
	 * 逻辑删除的回收站文件夹
	 */
	private String recycleBinFolder = warHome + "/recycle_bin";
	
	/**
	 * 是否记住当前url列表的在第几行
	 */
	private boolean rememberPage = false;
	
	/**
	 * 默认字体
	 */
	private String defaultFont = null;

	/**
	 * @return the warHome
	 */
	public String getWarHome() {
		return warHome;
	}

	/**
	 * @param warHome the warHome to set
	 */
	public void setWarHome(String warHome) {
		this.warHome = warHome;
	}

	/**
	 * @return the clusterMode
	 */
	boolean isClusterMode() {
		return clusterMode;
	}

	/**
	 * @param clusterMode the clusterMode to set
	 */
	void setClusterMode(boolean clusterMode) {
		this.clusterMode = clusterMode;
	}

	/**
	 * @return the cloudNodeInfoAuto
	 */
	boolean isCloudNodeInfoAuto() {
		return cloudNodeInfoAuto;
	}

	/**
	 * @param cloudNodeInfoAuto the cloudNodeInfoAuto to set
	 */
	void setCloudNodeInfoAuto(boolean cloudNodeInfoAuto) {
		this.cloudNodeInfoAuto = cloudNodeInfoAuto;
	}

	/**
	 * @return the databaseProductName
	 */
	String getDatabaseProductName() {
		return databaseProductName;
	}

	/**
	 * @param databaseProductName the databaseProductName to set
	 */
	void setDatabaseProductName(String databaseProductName) {
		this.databaseProductName = databaseProductName;
	}

	/**
	 * @return the multiDb
	 */
	boolean isMultiDb() {
		return multiDb;
	}

	/**
	 * @param multiDb the multiDb to set
	 */
	void setMultiDb(boolean multiDb) {
		this.multiDb = multiDb;
	}

	/**
	 * @return the systemDebugMode
	 */
	boolean isSystemDebugMode() {
		return systemDebugMode;
	}

	/**
	 * @param systemDebugMode the systemDebugMode to set
	 */
	void setSystemDebugMode(boolean systemDebugMode) {
		this.systemDebugMode = systemDebugMode;
	}

	/**
	 * @return the clusterIdPrefix
	 */
	String getClusterIdPrefix() {
		return clusterIdPrefix;
	}

	/**
	 * @param clusterIdPrefix the clusterIdPrefix to set
	 */
	void setClusterIdPrefix(String clusterIdPrefix) {
		this.clusterIdPrefix = clusterIdPrefix;
	}

	/**
	 * @return the generateIdFromDb
	 */
	boolean isGenerateIdFromDb() {
		return generateIdFromDb;
	}

	/**
	 * @param generateIdFromDb the generateIdFromDb to set
	 */
	void setGenerateIdFromDb(boolean generateIdFromDb) {
		this.generateIdFromDb = generateIdFromDb;
	}

	/**
	 * @return the userUniqueLogin
	 */
	boolean isUserUniqueLogin() {
		return userUniqueLogin;
	}

	/**
	 * @param userUniqueLogin the userUniqueLogin to set
	 */
	void setUserUniqueLogin(boolean userUniqueLogin) {
		this.userUniqueLogin = userUniqueLogin;
	}

	/**
	 * @return the defaultPageSize
	 */
	int getDefaultPageSize() {
		return defaultPageSize;
	}

	/**
	 * @param defaultPageSize the defaultPageSize to set
	 */
	void setDefaultPageSize(int defaultPageSize) {
		this.defaultPageSize = defaultPageSize;
	}

	/**
	 * @return the defaultBatchSize
	 */
	public int getDefaultBatchSize() {
		return defaultBatchSize;
	}

	/**
	 * @param defaultBatchSize the defaultBatchSize to set
	 */
	public void setDefaultBatchSize(int defaultBatchSize) {
		this.defaultBatchSize = defaultBatchSize;
	}

	/**
	 * @return the schedulerStart
	 */
	boolean isSchedulerStart() {
		return schedulerStart;
	}

	/**
	 * @param schedulerStart the schedulerStart to set
	 */
	void setSchedulerStart(boolean schedulerStart) {
		this.schedulerStart = schedulerStart;
	}

	/**
	 * @return the appDescription
	 */
	String getAppDescription() {
		return appDescription;
	}

	/**
	 * @param appDescription the appDescription to set
	 */
	void setAppDescription(String appDescription) {
		this.appDescription = appDescription;
	}

	/**
	 * @return the logRequest
	 */
	boolean isLogRequest() {
		return logRequest;
	}

	/**
	 * @param logRequest the logRequest to set
	 */
	void setLogRequest(boolean logRequest) {
		this.logRequest = logRequest;
	}

	/**
	 * @return the createPythonLibIfNotExist
	 */
	public boolean isCreatePythonLibIfNotExist() {
		return createPythonLibIfNotExist;
	}

	/**
	 * @param createPythonLibIfNotExist the createPythonLibIfNotExist to set
	 */
	public void setCreatePythonLibIfNotExist(boolean createPythonLibIfNotExist) {
		this.createPythonLibIfNotExist = createPythonLibIfNotExist;
	}
	
	/**
	 * @return the createPerlIfNotExist
	 */
	public boolean isCreatePerlIfNotExist() {
		return createPerlIfNotExist;
	}

	/**
	 * @param createPerlIfNotExist the createPerlIfNotExist to set
	 */
	public void setCreatePerlIfNotExist(boolean createPerlIfNotExist) {
		this.createPerlIfNotExist = createPerlIfNotExist;
	}

	/**
	 * @return the logicDeleteFile
	 */
	public boolean isLogicDeleteFile() {
		return logicDeleteFile;
	}

	/**
	 * @param logicDeleteFile the logicDeleteFile to set
	 */
	public void setLogicDeleteFile(boolean logicDeleteFile) {
		this.logicDeleteFile = logicDeleteFile;
	}

	/**
	 * @return the recycleBinFolder
	 */
	public String getRecycleBinFolder() {
		return recycleBinFolder;
	}

	/**
	 * @param recycleBinFolder the recycleBinFolder to set
	 */
	public void setRecycleBinFolder(String recycleBinFolder) {
		this.recycleBinFolder = recycleBinFolder;
	}

	public boolean isRememberPage() {
		return rememberPage;
	}

	public void setRememberPage(boolean rememberPage) {
		this.rememberPage = rememberPage;
	}

	public String getDefaultFont() {
		return defaultFont;
	}

	public void setDefaultFont(String defaultFont) {
		this.defaultFont = defaultFont;
	}

}