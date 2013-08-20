/*
 * 系统名称: QuickBundle --> rmdemo
 * 
 * 文件名称: org.quickbundle.project.common.dao --> IRmCommonDao.java
 * 
 * 功能描述:
 * 
 * 版本历史:
 * 2006-3-14 10:07:47 创建1.0.0版 (baixiaoyong)
 * 
 */
package org.quickbundle.project.common.dao;

import java.util.List;

import org.springframework.jdbc.core.RowMapper;

/**
 * 功能、用途、现存BUG:
 * 
 * @author 白小勇
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public interface IRmCommonDao {
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param strsql 要执行的sql语句
     * @param rowMapper 回调方法
     * @return 自己控制的对象列表
     */
    public List doQuery(String strsql, RowMapper rowMapper);
    
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param strsql 要执行的sql语句
     * @param rowMapper 回调方法
     * @param no 当前页数
     * @param size 每页记录数
     * @return 自己控制的对象列表
     */
    public List doQueryStartIndex(String strsql, RowMapper rowMapper, int no, int size);
    
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param strsql 要执行的sql语句
     * @param rowMapper 回调方法
     * @return 自己控制的对象
     */
    public Object doQueryForObject(String strsql, RowMapper rowMapper);
    
    /**
     * 通用的方法，执行查询，返回int
     *
     * @param strsql 要执行的sql语句
     * @return 查询结果int
     */
    public int doQueryForInt(String strsql);
    
    /**
     * sql带?及参数，执行查询，返回int
     *
     * @param strsql 要执行的sql语句
     * @param aObj ?对应的值
     * @return 查询结果int
     */
    public int doQueryForInt(String strsql, Object[] aObj);
    
    /**
     * 通用的方法，执行查询，返回long
     *
     * @param strsql 要执行的sql语句
     * @return 查询结果long
     */
    public long doQueryForLong(String strsql);
    
    /**
     * 通用的方法，执行更新，返回更新的记录条数
     *
     * @param strsql 要执行的sql语句
     * @return 更新记录条数
     */
    public int doUpdate(String strsql);

	/**
     * 执行更新，带?及参数，返回更新的记录条数
     * 
     * @param strsql 带 ?的SQL语句
     * @param aObj ?对应的值 
	 * @return
	 */
	public int doUpdate(String strsql, Object[] aObj);
	
	/**
	 * 执行批量更新sql，返回更新的记录条数
	 * 
	 * @param strsql
	 * @return
	 */
	public int[] doBatchUpdate(String[] strsql);
	
	/** 
	 * 执行批量更新，带?及参数，返回更新的记录条数
	 * 
	 * @param strsql 带 ?的SQL语句
	 * @param aObj ?对应的值
	 * @return
	 */
	public int[] doBatchUpdate(String strsql, Object[][] aaObj);

}