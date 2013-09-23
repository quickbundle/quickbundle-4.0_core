package org.quickbundle.base.beans;

import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

import org.quickbundle.ICoreConstants;
import org.quickbundle.base.beans.factory.RmIdFactory;
import org.quickbundle.config.RmBaseConfig;
import org.quickbundle.itf.base.IRmIdWrapper;
import org.quickbundle.tools.context.RmBeanHelper;
import org.quickbundle.tools.support.log.RmLogHelper;

public class DefaultIdWrapper implements IRmIdWrapper {
	
	protected TableIdRuleVo ruleVo = null;
	
	//开发模式下每次都查表获得最新ID的SQL
	private String sqlSelectMax = null;
	
	//生产模式下的ID增长Long
	private AtomicLong atomicLong = null;
	
	public DefaultIdWrapper(TableIdRuleVo ruleVo) {
		this.ruleVo = ruleVo;
	}
	
	public void init() {
    	String sql = getSqlSelectMax();
    	if(RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
    		sqlSelectMax = sql;
    	}  else {
    		try {
    			List<String> maxIds = RmBeanHelper.getCommonServiceInstance().queryForList(sql, String.class);
    			long lTableId = getMaxIdOrDefault(maxIds.size()==0 ? null : maxIds.get(0));
    			atomicLong = new AtomicLong(lTableId);
    		} catch (Exception e) {
    			e.printStackTrace();
    			RmLogHelper.getLogger(RmIdFactory.class).error("初始化" + ruleVo.getTableName() + "的最大id失败:" + e.toString());
    		}
    	}
	}
	
	String getIdPrefix() {
		return RmBaseConfig.getSingleton().getClusterIdPrefix() + ruleVo.getTableCode();
	}
	
    
    //根据 集群+table的前缀和maxId，获取下一个可用值或默认起始值
   protected long getMaxIdOrDefault(String maxId) {
    	long result = 0L;
		if(maxId != null && maxId.length() > 0) {
			if(maxId.length() > 19) {
				result = Long.parseLong(maxId.substring(0, 19)) + 1;
			} else {
				result = Long.parseLong(maxId) + 1;
			}
		} else {
			result = Long.parseLong(firstValue());
		}
    	return result;
    }

	protected String firstValue() {
		return RmBaseConfig.getSingleton().getClusterIdPrefix() + ruleVo.getTableCode() + "00000000001";
	}

	public synchronized String[] nextValue(int length) {
        //generateIdFromDb模式下每次都查询的sql
        if(RmBaseConfig.getSingleton().isGenerateIdFromDb()) {
            List<String> maxIds = RmBeanHelper.getCommonServiceInstance().queryForList(sqlSelectMax, String.class);
            long lTableId = getMaxIdOrDefault(maxIds.size()==0 ? null : maxIds.get(0));
            if(atomicLong == null || atomicLong.longValue() < lTableId) {
            	atomicLong = new AtomicLong(lTableId);
            }
        }
        //返回值
        String[] ids = new String[length];
        for (int i = 0; i < ids.length; i++) {
        	ids[i] = String.valueOf(atomicLong.getAndIncrement());
		}
        return ids;
	}
    
    //根据<table table_code="2003" table_name="RM_AFFIX" id_name="ID"/>和clusterIdPrefix，获得查询最大值的sql
    String getSqlSelectMax() {
		StringBuilder sql = new StringBuilder();
		sql.append("select max(");
		sql.append(ruleVo.getIdName());
		sql.append(") max_id from ");
		sql.append(ruleVo.getTableName());
		sql.append(" where ");
		sql.append(parseColumn(ruleVo.getIdName()));
		sql.append(" like '");
		sql.append(getIdPrefix());
		sql.append("%'");
    	return sql.toString();
    }
    
    private String parseColumn(String idName) {
    	StringBuilder result = new StringBuilder();
    	String dpn = RmBaseConfig.getSingleton().getDatabaseProductName();
    	//db2需要char(columnName) like '10001000%'
    	if(dpn == null 
    			|| ICoreConstants.DatabaseProductType.DB2.getDatabaseProductName().equals(dpn)
    			|| dpn.startsWith(ICoreConstants.DatabaseProductType.DB2.getDatabaseProductName() + "/")) {
    		result.append("char(").append(idName).append(")");
    		return result.toString();
    	} else {
    		return idName;
    	}
    }

}
