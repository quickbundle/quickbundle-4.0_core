/*
 * 系统名称: QuickBundle --> rmdemo
 * 
 * 文件名称: 
 * 
 * 功能描述:
 * 
 * 版本历史: 2005-9-23 15:25:24 创建1.0.0版 (baixiaoyong)
 *  
 */
package org.quickbundle.project.common.dao.impl;

import java.util.List;

import org.quickbundle.base.dao.RmJdbcTemplate;
import org.quickbundle.project.common.dao.IRmCommonDao;
import org.springframework.jdbc.core.RowMapper;

/**
 * 功能、用途、现存BUG:
 * 
 * @author 白小勇
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public class RmCommonDao extends RmJdbcTemplate implements IRmCommonDao {
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param strsql 要执行的sql语句
     * @param rowMapper 回调方法
     * @return 自己控制的对象列表
     */
    public List doQuery(String strsql, RowMapper rowMapper) {
        return query(strsql, rowMapper);
    }
    
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param strsql 要执行的sql语句
     * @param rowMapper 回调方法
     * @param no 当前页数
     * @param size 每页记录数
     * @return 自己控制的对象列表
     */
    public List doQueryStartIndex(String strsql, RowMapper rowMapper, int startIndex, int size) {
        return query(strsql, rowMapper, startIndex, size);
    }


    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param strsql 要执行的sql语句
     * @param rowMapper 回调方法
     * @return 自己控制的对象
     */
    public Object doQueryForObject(String strsql, RowMapper rowMapper) {
        return queryForObject(strsql, rowMapper);
    }
    
    /**
     * 通用的方法，执行查询，返回int
     *
     * @param strsql 要执行的sql语句
     * @return 查询结果int
     */
    public int doQueryForInt(String strsql) {
        return queryForInt(strsql);
    }
    
    /**
     * sql带?及参数，执行查询，返回int
     *
     * @param strsql 要执行的sql语句
     * @param aObj ?对应的值
     * @return 查询结果int
     */
    public int doQueryForInt(String strsql, Object[] aObj) {
    	return queryForInt(strsql, aObj);
    }
    
    /**
     * 通用的方法，执行查询，返回long
     *
     * @param strsql 要执行的sql语句
     * @return 查询结果long
     */
    public long doQueryForLong(String strsql) {
        return queryForLong(strsql);
    }
    
    /**
     * 通用的方法，执行更新，返回更新的记录条数
     *
     * @param strsql 要执行的sql语句
     * @return 更新记录条数
     */
    public int doUpdate(String strsql) {
        return update(strsql);
    }
    
	/**
     * 执行更新，带?及参数，返回更新的记录条数
     * 
     * @param strsql 带 ?的SQL语句
     * @param aObj ?对应的值 
	 * @return
	 */
    public int doUpdate(String strsql, Object[] aObj) {
        return update(strsql, aObj);
    }

	/**
	 * 执行批量更新sql，返回更新的记录条数
	 * 
	 * @param strsql
	 * @return
	 */
	public int[] doBatchUpdate(String[] strsql) {
		return batchUpdate(strsql);
	}

	/** 
	 * 执行批量更新，带?及参数，返回更新的记录条数
	 * 
	 * @param strsql 带 ?的SQL语句
	 * @param aObj ?对应的值
	 * @return
	 */
	public int[] doBatchUpdate(String strsql, Object[][] aaObj) {
		return batchUpdate(strsql, aaObj, new RmJdbcTemplate.CircleVoArray() {
			public Object[] getArgs(Object obj) {
				return (Object[])obj;
			}
		});
	}
}