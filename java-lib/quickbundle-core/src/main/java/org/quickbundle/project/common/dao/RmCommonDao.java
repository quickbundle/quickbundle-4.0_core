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
package org.quickbundle.project.common.dao;

import org.quickbundle.base.dao.RmJdbcTemplate;

/**
 * 功能、用途、现存BUG:
 * 
 * @author 白小勇
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public class RmCommonDao extends RmJdbcTemplate {
    /**
     * 通用的方法，返回自己控制的对象
     *
     * @param sql 要执行的sql语句
     * @param requiredType 需要的类型
     * @return
     */
    public <T> T doQueryForObject(String sql, Class<T> requiredType) {
    	return queryForObject(sql, getSingleColumnRowMapper(requiredType));
    }
}