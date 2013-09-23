/*
 * 系统名称: QuickBundle --> rmdemo
 * 
 * 文件名称: org.quickbundle.project.common.service --> IRmCommonService.java
 * 
 * 功能描述:
 * 
 * 版本历史:
 * 2006-3-14 10:06:10 创建1.0.0版 (baixiaoyong)
 * 
 */
package org.quickbundle.project.common.service;

import java.util.List;

import org.quickbundle.itf.IExecuteCode;
import org.quickbundle.project.common.vo.RmCommonVo;
import org.springframework.jdbc.core.RowMapper;

/**
 * 功能、用途、现存BUG:
 * 
 * @author 白小勇
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public interface IRmCommonService {
	/**
	 * 查询sql，返回RmcommonVo
	 * 
	 * @param sql 要执行的sql语句
	 * @return
	 */
	public List<RmCommonVo> doQuery(String sql);
	
    /**
     * 查询sql，返回RowMapper中自定义的对象
     *
     * @param sql 要执行的sql语句
     * @param rowMapper 回调方法
     * @return 对象列表
     */
    public List doQuery(String sql, RowMapper rowMapper);
    
    /**
     * 以size作为分页大小，取回第no页的记录
     * 查询sql，返回RowMapper中自定义的对象
     *
     * @param sql 要执行的sql语句
     * @param rowMapper 回调方法
     * @param no 当前页数
     * @param size 每页记录数
     * @return 对象列表
     */
    public List doQuery(String sql, RowMapper rowMapper, int no, int size);
    
    /**
     * 从指定的startIndex作为第一条，获取size条记录
     * 
     * @param sql 要执行的sql语句
     * @param rowMapper 回调方法
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 获取的记录数
     * @return 对象列表
     */
    public List doQueryStartIndex(String sql, RowMapper rowMapper, int startIndex, int size);

	/**
	 * 以size作为分页大小，取回第no页的记录
	 * 查询sql，返回RmcommonVo
	 * 
	 * @param sql
	 * @param no 当前页数
	 * @param size 每页记录数
	 * @return
	 */
	public List<RmCommonVo> doQuery(String sql, int no, int size);
	
	/**
	 * 从指定的startIndex作为第一条，获取size条记录
	 * 
	 * @param sql SQL语句
	 * @param startIndex 开始位置(第一条是1，第二条是2...)
	 * @param size 获取的记录数
	 * @return 对象列表
	 */
	public List<RmCommonVo> doQueryStartIndex(String sql, int startIndex, int size);
	
	/**
	 * 查询sql，返回RmcommonVo，自动分页
	 * 
	 * @param sql SQL语句
	 * @return
	 */
	public List<RmCommonVo> doQueryPage(String sql);
	
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param sql 要执行的sql语句
     * @return RmCommonVo对象
     */
    public RmCommonVo doQueryForObject(String sql);
	
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param sql 要执行的sql语句
     * @param requiredType 需要的类型
     * @return
     */
    public <T> T doQueryForObject(String sql, Class<T> requiredType);
    
    /**
     * sql带?及参数，执行查询，返回T
     * 
     * @param sql 要执行的sql语句
     * @param args ?对应的值
     * @param requiredType 需要的类型
     * @return
     */
    public <T>T doQueryForObject(String sql, Object[] args, Class<T> requiredType);
    
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param sql 要执行的sql语句
     * @param rowMapper 回调方法
     * @return 单个对象
     */
    public <T> T doQueryForObject(String sql, RowMapper<T> rowMapper);
    
    /**
     * 通用的方法，执行查询，返回int
     *
     * @param sql 要执行的sql语句
     * @return 查询结果int
     */
    public int doQueryForInt(String sql);
    
    /**
     * 通用的方法，执行查询，返回long
     *
     * @param sql 要执行的sql语句
     * @return 查询结果long
     */
    public long doQueryForLong(String sql);
    
    /**
     * 执行更新，返回更新的记录条数
     *
     * @param sql 要执行的sql语句
     * @return 更新记录条数
     */
    public int doUpdate(String sql);
    
    /**
     * 执行更新，带?及参数，返回更新的记录条数
     * 
     * @param sql 带 ?的SQL语句
     * @param aObj ?对应的值
     * @return
     */
    public int doUpdate(String sql, Object[] aObj);
    
    /**
     * 执行批量更新sql，返回更新的记录条数
     * 
     * @param sql
     * @return
     */
	public int[] doUpdateBatch(String[] sql);
	
	/** 执行批量更新，带?及参数，返回更新的记录条数
	 * @param sql 带 ?的SQL语句
	 * @param aObj ?对应的值
	 * @return
	 */
	public int[] doUpdateBatch(String sql, Object[][] aaObj);

	/**
	 * 执行自定义定义代码，在一个事务中
	 * @param executeCode
	 * @return
	 */
	public Object execute(IExecuteCode executeCode);
	
	/**
	 * 查询sql语句，将第1列和第2列放入数组，结果集作为二维数组返回
	 * 
	 * @param sql select value, name from table1
	 * @return new String[count(*)][2]
	 */
	public String[][] paseToArrays(String sql);
	
	/**
	 * 查询sql语句，rowMapper完成一维数组的创建，整个结果集作为二维数组返回
	 * 
	 * @param sql select value, name from table1
	 * @param rowMapper 创建一维数组的回调实现
	 * @return new String[count(*)][2]
	 * @return
	 */
	public String[][] paseToArrays(String sql, RowMapper rowMapper);
}