package org.quickbundle.base.beans;

import org.quickbundle.tools.context.RmBeanHelper;
import org.springframework.dao.OptimisticLockingFailureException;

public class NumberFromOneService {

	public long initIdPool(TableIdRuleVo ruleVo, long blocksize) {
		long oldId;
		Long oldPoolLastId = RmBeanHelper.getCommonServiceInstance().doQueryForObject("select LAST_ID from RM_ID_POOL where ID=?",
				new String[] { ruleVo.getTableName() }, Long.class);
		if(oldPoolLastId == null) {
			oldId = getMaxIdFromTable(ruleVo);
		} else {
			oldId = oldPoolLastId.longValue();
		}
		long newPoolLastId = oldId + blocksize;
		if(oldPoolLastId == null) {
			RmBeanHelper.getCommonServiceInstance().doUpdate("insert into RM_ID_POOL (ID, VERSION, LAST_ID) values(?, ?, ?)",
					new Object[] { ruleVo.getTableName(), 1, newPoolLastId });
		} else {
			int updateCount = RmBeanHelper.getCommonServiceInstance().doUpdate("update RM_ID_POOL set LAST_ID=?, VERSION=VERSION+1 where ID=? and LAST_ID=?",
					new Object[] { newPoolLastId, ruleVo.getTableName(), oldPoolLastId });
			if(updateCount == 0) {
				throw new OptimisticLockingFailureException("can not update lastId that read this time: " + ruleVo.getTableName());
			}
		}
		return oldPoolLastId;
	}

	private long getMaxIdFromTable(TableIdRuleVo ruleVo) {
		StringBuilder sql = new StringBuilder();
		sql.append("select max(");
		sql.append(ruleVo.getIdName());
		sql.append(") max_id from ");
		sql.append(ruleVo.getTableName());
		Long maxIdObj = RmBeanHelper.getCommonServiceInstance().doQueryForObject(sql.toString(), Long.class);
		long maxId;
		if (maxIdObj == null) {
			maxId = 0;
		} else {
			maxId = maxIdObj.longValue();
		}
		maxId++;
		return maxId;
	}

	public long acquireId(TableIdRuleVo ruleVo, long blocksize) {
		long oldPoolLastId = RmBeanHelper.getCommonServiceInstance().doQueryForObject("select LAST_ID from RM_ID_POOL where ID=?",
				new String[] { ruleVo.getTableName() }, Long.class);
		long newPoolLastId = oldPoolLastId + blocksize;
		int updateCount = RmBeanHelper.getCommonServiceInstance().doUpdate("update RM_ID_POOL set LAST_ID=?, VERSION=VERSION+1 where ID=? and LAST_ID=?",
				new Object[] { newPoolLastId, ruleVo.getTableName(), oldPoolLastId });
		if (updateCount == 0) {
			throw new OptimisticLockingFailureException("can not update lastId that read this time: " + ruleVo.getTableName());
		}
		return oldPoolLastId;
	}
}
