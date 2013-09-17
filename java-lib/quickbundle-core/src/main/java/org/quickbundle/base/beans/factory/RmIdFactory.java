package org.quickbundle.base.beans.factory;

import java.io.File;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.Node;
import org.quickbundle.config.RmBaseConfig;
import org.quickbundle.itf.base.IRmIdFactory;
import org.quickbundle.project.common.service.IRmCommonService;
import org.quickbundle.project.multidb.RmMultiDbHolder;
import org.quickbundle.tools.context.RmBeanHelper;
import org.quickbundle.tools.helper.xml.RmXmlHelper;
import org.quickbundle.tools.support.log.RmLogHelper;
import org.quickbundle.tools.support.path.RmPathHelper;
import org.quickbundle.util.RmSequenceMap;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * ID生成器单例
 * 
 * @author 白小勇
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public class RmIdFactory implements IRmIdFactory{
	private static String databaseProductName_DB2 = "DB2";
	private static String databaseProductName_DB2NT = "DB2/NT";
	
	
	//批查询的数量
    public static int MAX_BATCH_SIZE = RmBaseConfig.getSingleton().getDefaultBatchSize();
    
	//表名tableName-->ID
	private Map<String, AtomicLong> mId = null;
	
	//开发模式下每次都查表获得最新ID，表名tableName --> {sql, tablePrefix}
	private Map<String, String[]> mTableName_sql = null;

	private File getIdXml() {
		File idXml = new File(RmPathHelper.getWebInfDir() + "/config/rm/id.xml");
		if(!idXml.exists()) {
			idXml = new File(RmPathHelper.getWebInfDir() + "/config/jdbc/id.xml");
		}
		return idXml;
	}
	
    @Transactional(propagation=Propagation.NOT_SUPPORTED)
    public void initBeanFactory() {
        try {
            long startTime = System.currentTimeMillis();
            //初始化单例对象
            this.mId = new HashMap<String, AtomicLong>();
            //存放table_name -> <table table_code="2003" table_name="RM_AFFIX" id_name="ID"/>
            Map<String, Element> mTableName_Ele = new RmSequenceMap<String, Element>();
            //id.xml命名空间
            Map<String, String> defaultNameSpaceMap = new HashMap<String, String>();  
            defaultNameSpaceMap.put("q", "http://www.quickbundle.org/schema");
            //读入id.xml
            Document docId_xml = RmXmlHelper.parse(getIdXml().toString(), defaultNameSpaceMap);
            List<Element> lTable = docId_xml.selectNodes("/q:RmIdFactory/q:table");
            for(Element eleTable : lTable) {
            	String tableName = eleTable.valueOf("@table_name").toUpperCase();
            	mTableName_Ele.put(tableName, eleTable);
            	//this.mId.put(tableName, new AtomicLong());//放弃对mId初始化。
            }
            //generateIdFromDb模式下每次都查询的sql
            if(RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
            	this.mTableName_sql = new HashMap<String, String[]>();
            }
            if(RmBaseConfig.getSingleton().isInitIdBatch()) { //Batch模式下批量查询maxId
            	doInitIdBatch(mTableName_Ele);
            } else {
            	doInitId(mTableName_Ele);
            }
            RmLogHelper.getLogger(this.getClass()).info("init " + mTableName_Ele.size() + " tables, cost " + (System.currentTimeMillis()-startTime) + " milliseconds!");
        } catch (Exception e) {
            e.printStackTrace();
            RmLogHelper.getLogger(RmIdFactory.class).error("id.xml初始化失败:" + e.toString());
        }
    }
    
    //根据 集群+table的前缀和maxId，获取下一个可用值或默认起始值
    long getMaxIdOrDefault(String clusterTablePrefix, String maxId) {
    	long result = 0L;
		if(maxId != null && maxId.length() > 0) {
			if(maxId.length() > 19) {
				result = Long.parseLong(maxId.substring(0, 19)) + 1;
			} else {
				result = Long.parseLong(maxId) + 1;
			}
		} else {
			result = Long.parseLong(clusterTablePrefix + "00000000001");
		}
    	return result;
    }
    
    //TODO 扩展为在多集群高并发下获得 从1开始auto_increment的id
    //根据<table table_code="2003" table_name="RM_AFFIX" id_name="ID"/>和clusterIdPrefix，获得查询最大值的sql
    String getSqlSelectMax(Element eleTable, String clusterIdPrefix) {
        String tableName = eleTable.valueOf("@table_name");
		String tablePrefix = clusterIdPrefix + eleTable.valueOf("@table_code");
		String idName = eleTable.valueOf("@id_name");
		StringBuilder sql = new StringBuilder();
		sql.append("select ");
		sql.append("max(");
		sql.append(idName);
		sql.append(") ");
		sql.append("max_id from ");
		sql.append(tableName);
		sql.append(" where ");
		sql.append(parseColumn(idName));
		sql.append(" like '");
		sql.append(tablePrefix);
		sql.append("%'");
    	return sql.toString();
    }
    
    private String parseColumn(String idName) {
    	StringBuilder result = new StringBuilder();
    	if(databaseProductName_DB2.equals(RmBaseConfig.getSingleton().getDatabaseProductName())
    			|| databaseProductName_DB2NT.equals(RmBaseConfig.getSingleton().getDatabaseProductName())) {
    		result.append("char(").append(idName).append(")");
    		return result.toString();
    	} else {
    		return idName;
    	}
    }
    
    void doInitIdBatch(Map<String, Element> mTableName_Ele) {
        int batchSize = 0;
        Map<String, Element> todoTable = new RmSequenceMap<String, Element>();
        for (Map.Entry<String, Element> en: mTableName_Ele.entrySet()) {
            String tableName = en.getKey().toUpperCase();
        	Element eleTable = en.getValue();
        	
        	if("1".equals(eleTable.valueOf("@multi_db")) || batchSize >= MAX_BATCH_SIZE) {
        		doInitIdBatchQuery(todoTable);
        		batchSize = 0;
        		todoTable.clear();
        	}
        	todoTable.put(tableName, eleTable);
        	batchSize ++;
        	if("1".equals(eleTable.valueOf("@multi_db"))){
        		doInitIdBatchQuery(todoTable);
        		batchSize = 0;
        		todoTable.clear();
        	}
        }
        doInitIdBatchQuery(todoTable);
    }
    
    void doInitIdBatchQuery(Map<String, Element> todoTable) {
    	if(todoTable.size() == 0) {
    		return;
    	}
        IRmCommonService cService = RmBeanHelper.getCommonServiceInstance();
        //取到当前的集群节点ID
        String clusterIdPrefix = RmBaseConfig.getSingleton().getClusterIdPrefix();
        StringBuilder sql = new StringBuilder();
        int indexThisBatch = 0;
        List<String> lTmpTableName = new ArrayList<String>();
        List<String> lTmpTablePrefix = new ArrayList<String>();
    	for (Map.Entry<String, Element> en: todoTable.entrySet()) {
            String tableName = en.getKey();
        	Element eleTable = en.getValue();
    		String tablePrefix = clusterIdPrefix + eleTable.valueOf("@table_code");
    		lTmpTableName.add(tableName);
    		lTmpTablePrefix.add(tablePrefix);
    		String sqlSingle = getSqlSelectMax(eleTable, clusterIdPrefix);
    		if(RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
    			mTableName_sql.put(tableName, new String[]{sqlSingle, tablePrefix});
    		}
    		if(sql.length() > 0) {
    			sql.append(" union all ");
    		}
    		sql.append(sqlSingle);
    		indexThisBatch ++;
    	}
    	if(!RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
    		try {
    			List<String> lMax_id = cService.doQuery(sql.toString(), new RowMapper() {
    				public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
    					return rs.getString("max_id");
    				}
    			});
    			indexThisBatch = 0; //归零
    			for(String maxId : lMax_id) {
    				long lTableId = getMaxIdOrDefault(lTmpTablePrefix.get(indexThisBatch), maxId);
    	    		this.mId.put(lTmpTableName.get(indexThisBatch), new AtomicLong(lTableId));
    				indexThisBatch ++;
    			}
    		} catch (BadSqlGrammarException e) {
    			RmLogHelper.getLogger(this.getClass()).warn("从主数据源初始化" + todoTable.keySet() + "的最大id失败:" + e.toString());
    			if("1".equals(todoTable.values().toArray(new Element[0])[0].valueOf("@multi_db"))) {
    				doBadSqlGrammar(sql.toString(), todoTable.keySet().toArray(new String[0])[0], lTmpTablePrefix.get(0));
    			}
    		}catch (Exception e) {
    			e.printStackTrace();
    			RmLogHelper.getLogger(RmIdFactory.class).error("初始化" + todoTable.keySet() + "的最大id失败:" + e.toString());
    		}
    	}
    }
    
    void doInitId( Map<String, Element> mTableName_Ele) {
        IRmCommonService cService = RmBeanHelper.getCommonServiceInstance();
        //取到当前的集群节点ID
        String clusterIdPrefix = RmBaseConfig.getSingleton().getClusterIdPrefix();
        for (Map.Entry<String, Element> en: mTableName_Ele.entrySet()) {
            String tableName = en.getKey();
        	Element eleTable = en.getValue();
        	String clusterTablePrefix = clusterIdPrefix + eleTable.valueOf("@table_code");
        	String strsql = getSqlSelectMax(eleTable, clusterIdPrefix);
        	if(RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
        		mTableName_sql.put(tableName, new String[]{strsql, clusterTablePrefix});
        	} 
        	if(!RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
        		try {
        			List<String> lMax_id = cService.doQuery(strsql, new RowMapper() {
        				public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
        					return rs.getString("max_id");
        				}
        			});
        			long lTableId = getMaxIdOrDefault(clusterTablePrefix, lMax_id.size() > 0 ? lMax_id.get(0) : null);
        			this.mId.put(tableName, new AtomicLong(lTableId));
        		} catch (BadSqlGrammarException e) {
        			RmLogHelper.getLogger(this.getClass()).warn("从主数据源初始化" + tableName + "的最大id失败:" + e.toString());
        			if("1".equals(eleTable.valueOf("@multi_db"))) {
        				doBadSqlGrammar(strsql, tableName, clusterTablePrefix);
        			}
        		}catch (Exception e) {
        			e.printStackTrace();
        			RmLogHelper.getLogger(RmIdFactory.class).error("初始化" + tableName + "的最大id失败:" + e.toString());
        		}
        	}
        }
    }
    
    void doBadSqlGrammar(String sql, String tableName, String clusterTablePrefix) {
    	IRmCommonService cService = RmBeanHelper.getCommonServiceInstance();
        //循环分频道数据源
        String xmlFile = RmPathHelper.getWebInfDir() + "/config/spring/rm.public.applicationContext.xml";
        try {
            Document doc = RmXmlHelper.parse(RmXmlHelper.formatToUrl(xmlFile));
            for (Iterator itBean = doc.selectNodes("/beans/node()[@parent='abstractDataSource']").iterator(); itBean.hasNext();) {
                Node nBean = (Node) itBean.next();
                String beanId = nBean.valueOf("@id");
                if(beanId != null && beanId.startsWith("dataSource_")) {
                    String channelId = beanId.substring("dataSource_".length());
                    //高度注意，切换到分频道数据库！！！
                    try {
                        RmMultiDbHolder.setChannelId(channelId);
                        List lMax_id = cService.doQuery(sql, new RowMapper() {
                            public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                                return rs.getString("max_id");
                            }
                        });
                        if(this.mId.get(tableName) == null) { //如果当前id未初始化
                        	this.mId.put(tableName, new AtomicLong(getMaxIdOrDefault(clusterTablePrefix, null)));
                        }
                        if(lMax_id.size() > 0 && lMax_id.get(0) != null) { //分库中有数据
                            if(Long.parseLong(lMax_id.get(0).toString()) + 1 > this.mId.get(tableName).longValue()) { //并且是最大的id
                            	this.mId.get(tableName).set(Long.parseLong(lMax_id.get(0).toString()) + 1);                                                
                            }
                        }
                    } catch (Exception e2) {
                        RmLogHelper.getLogger(this.getClass()).warn("从" + beanId + "查询" + tableName + "的最大id失败:" + e2.getMessage());
                    } finally {
                        RmMultiDbHolder.clearChannelId();
                    }
                }
            };
        } catch (Exception e2) {
            RmLogHelper.getLogger(this.getClass()).warn("从" + xmlFile + "初始化" + tableName + "的最大id失败:" + e2.getMessage());
        }
    }
    
    /**
     * 获得单例
     * @return
     */
    public static IRmIdFactory getIdFactory() {
        if(!isInitId) {
            synchronized (RmIdFactory.class) {
                if(!isInitId) {
                	idFactory = (IRmIdFactory) RmBeanFactory.getBean("org.quickbundle.itf.base.IRmIdFactory");
                	idFactory.initBeanFactory();
                    isInitId = true;
                }
            }
        }
        return idFactory;
    }

    public synchronized String[] requestIdInner(String tableName, int length) {
        if(idFactory == null && isInitId) {
            return null;
        }
        if(RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
        	String strsql = this.mTableName_sql.get(tableName)[0];
            List<String> lMax_id = RmBeanHelper.getCommonServiceInstance().doQuery(strsql, new RowMapper() {
                public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                    return rs.getString("max_id");
                }
            });
            long lTableId = getMaxIdOrDefault(this.mTableName_sql.get(tableName)[1], lMax_id.size() > 0 ? lMax_id.get(0) : null);
            if(this.mId.get(tableName) == null) {
            	this.mId.put(tableName, new AtomicLong());
            }
            if(lTableId > this.mId.get(tableName).longValue()) {
            	this.mId.get(tableName).set(lTableId);              	
            }
        }
        //返回值
        String[] ids = new String[length];
        for (int i = 0; i < ids.length; i++) {
        	long tmpId =this.mId.get(tableName).getAndIncrement();
        	ids[i] = String.valueOf(tmpId);
		}

        return ids;
    }
    
    /**
     * 获取单个唯一ID
     * 
     * @param tableName 表名
     * @return 返回内存中自增长的ID，未找到返回null
     */
    public static String requestId(String tableName) {
    	String[] ids = requestId(tableName, 1);
    	if(ids == null || ids.length == 0) {
    		return null;
    	}
    	return ids[0];
    }
    
    /**
     * 获取单个唯一ID，Long格式
     * 
     * @param tableName 表名
     * @return 返回内存中自增长的ID，未找到返回null
     */
    public static Long requestIdLong(String tableName) {
    	return new Long(requestId(tableName));
    }
    
    /**
     * 批量获取唯一ID
     * @param tableName 表名
     * @param length 批量数
     * @return 返回内存中自增长的ID，未找到返回null
     */
    public static String[] requestId(String tableName, int length) {
    	if(length < 1) {
    		return new String[0];
    	}
    	return getIdFactory().requestIdInner(tableName.toUpperCase(), length);
    }
    
    /**
     * 批量获取唯一ID，Long[]格式
     * @param tableName 表名
     * @param length 批量数
     * @return 返回内存中自增长的ID，未找到返回null
     */
    public static Long[] requestIdLong(String tableName, int length) {
    	String[] ids = requestId(tableName, length);
    	Long[] result = new Long[length];
    	for (int i = 0; i < ids.length; i++) {
    		result[i] = new Long(ids[i]);
		}
    	return result;
    }
    
	//全局单例
	private static IRmIdFactory idFactory = null;
	//全局单例的初始化标记，用于双检锁安全判断
	private static volatile boolean isInitId = false;
}