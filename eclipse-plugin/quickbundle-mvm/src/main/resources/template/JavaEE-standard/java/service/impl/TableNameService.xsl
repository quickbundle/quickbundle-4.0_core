<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:param name="thisFilePathName">
			<xsl:value-of select="$javaPackageTableDir"/>.service.impl --> <xsl:value-of select="$tableFormatNameUpperFirst"/>Service.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.service.impl;

import java.util.ArrayList;
import java.util.List;
		<xsl:if test="fn:matches(@parentChildTable, '\s*([\w_]+)\.([\w_]+)=([\w_]+)\.([\w_]+)\|([\w_]+)=([\w_]+)\.([\w_]+)\(([\w_]+)\.([\w_]+)\)\s*')">
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;

import org.quickbundle.project.RmProjectHelper;
import org.quickbundle.project.common.service.IRmCommonService;
import org.quickbundle.tools.helper.RmStringHelper;
import org.springframework.jdbc.core.RowMapper;
		</xsl:if>
import org.quickbundle.base.cache.RmSqlCountCache;
import org.quickbundle.base.service.RmService;

import <xsl:value-of select="$javaPackageTableDir"/>.dao.I<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao;
import <xsl:value-of select="$javaPackageTableDir"/>.service.I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service;
import <xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>
public class <xsl:value-of select="$tableFormatNameUpperFirst"/>Service extends RmService implements I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service, <xsl:value-of select="$ITableNameConstants"/> {
    
    /**
     * dao 表示: 数据访问层的实例
     */
    private I<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao dao = null;

    /**
     * 设置数据访问接口
     * 
     * @return
     */
    public I<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao getDao() {
        return dao;
    }

    /**
     * 获取数据访问接口
     * 
     * @param dao
     */
    public void setDao(I<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao dao) {
        this.dao = dao;
    }


    /**
     * 插入单条记录
     * 
     * @param vo 用于添加的VO对象
     * @return 若添加成功，返回新生成的Oid
     */
    public String insert(<xsl:value-of select="$TableNameVo"/> vo) {
        String id = getDao().insert(vo);
        //RmLogHelper.log(TABLE_LOG_TYPE_NAME, "插入了1条记录,id=" + String.valueOf(id));
        RmSqlCountCache.clearCount(TABLE_NAME);  //清除count记录数缓存
		return id;
    }
    
    /**
     * 插入多条记录
     *
     * @param vos 用于添加的VO对象数组
     * @return 返回新生成的id数组
     */
    public String[] insert(<xsl:value-of select="$TableNameVo"/>[] vos) {
        String[] aId = getDao().insert(vos);
        //RmLogHelper.log(TABLE_LOG_TYPE_NAME, "插入了" + vos.length + "条记录,id=" + RmStringHelper.ArrayToString(aId, ","));
        RmSqlCountCache.clearCount(TABLE_NAME);  //清除count记录数缓存
        return aId;
    }

    /**
     * 删除单条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(String id) {
		int sum = getDao().delete(id);
		//RmLogHelper.log(TABLE_LOG_TYPE_NAME, "删除了" + sum + "条记录,id=" + String.valueOf(id));
		RmSqlCountCache.clearCount(TABLE_NAME);  //清除count记录数缓存
		return sum;
    }

    /**
     * 删除多条记录
     * 
     * @param ids 用于删除的记录的ids
     * @return 成功删除的记录数
     */
    public int delete(String ids[]) {
		int sum = getDao().delete(ids);
        //RmLogHelper.log(TABLE_LOG_TYPE_NAME, "删除了" + sum + "条记录,id=" + RmStringHelper.ArrayToString(ids, ","));
        RmSqlCountCache.clearCount(TABLE_NAME);  //清除count记录数缓存
		return sum;
    }

    /**
     * 根据Id进行查询
     * 
     * @param id 用于查找的id
     * @return 查询到的VO对象
     */
    public <xsl:value-of select="$TableNameVo"/> find(String id) {
		<xsl:value-of select="$TableNameVo"/> vo = getDao().find(id);
        //RmLogHelper.log(TABLE_LOG_TYPE_NAME, "察看了1条记录,id=" + id);
		return vo;
    }

    /**
     * 更新单条记录
     * 
     * @param vo 用于更新的VO对象
     * @return 成功更新的记录数
     */
    public int update(<xsl:value-of select="$TableNameVo"/> vo) {
		int sum = getDao().update(vo);
        //RmLogHelper.log(TABLE_LOG_TYPE_NAME, "更新了" + sum + "条记录,id=" + String.valueOf(vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>()));
        RmSqlCountCache.clearCount(TABLE_NAME);  //清除count记录数缓存
		return sum;
    }

    /**
     * 批量更新修改多条记录
     * 
     * @param vos 更新的VO对象数组
     * @return 成功更新的记录最终数量
     */
	public int update(<xsl:value-of select="$TableNameVo"/>[] vos) {
		int[] sum = getDao().update(vos);
		int finalSum = 0;
		for (int i = 0; i <xsl:value-of select="$charLt"/> sum.length; i++) {
			finalSum += sum[i];
		}
		//RmLogHelper.log(TABLE_LOG_TYPE_NAME, "批量更新了" + finalSum + "条记录);
        RmSqlCountCache.clearCount(TABLE_NAME);  //清除count记录数缓存
		return finalSum;
	}
	
	/**
	 * 批量保存，没有主键的insert，有主键的update
	 * 
	 * @param vos 更新的VO对象数组
	 * @return new int[2]{insert的记录数, update的记录数}	
	 */
	public int[] insertUpdateBatch(<xsl:value-of select="$TableNameVo"/>[] vos) {
		int[] sum_insert_update = new int[2];
		List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> lInsert = new ArrayList<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>>();
		List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> lUpdate = new ArrayList<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>>();
		for (int i = 0; i <xsl:value-of select="$charLt"/> vos.length; i++) {
			if(vos[i].get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> vos[i].get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>().trim().length() > 0) {
				lUpdate.add(vos[i]);
			} else {
				lInsert.add(vos[i]);
			}
		}
		if(lInsert.size() > 0) {
			sum_insert_update[0] = insert(lInsert.toArray(new <xsl:value-of select="$TableNameVo"/>[0])).length;
		}
		if(lUpdate.size() > 0) {
			sum_insert_update[1] = update(lUpdate.toArray(new <xsl:value-of select="$TableNameVo"/>[0]));
		}
		return sum_insert_update;
	}

    /**
     * 查询总记录数，带查询条件
     * 
     * @param queryCondition 查询条件
     * @return 总记录数
     */
    public int getRecordCount(String queryCondition) {
		int sum = getDao().getRecordCount(queryCondition);
		//RmLogHelper.log(TABLE_LOG_TYPE_NAME, "查询到了总记录数,count=" + sum + ", queryCondition=" + queryCondition);
		return sum;
    }

    /**
     * 功能: 通过查询条件获得所有的VO对象列表，不带翻页查全部，只查询必要的字段
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字段
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String queryCondition, String orderStr) {
        return queryByCondition(queryCondition, orderStr, -1, -1);
    }

    /**
     * 功能: 通过查询条件获得所有的VO对象列表，带翻页，带排序字符，只查询必要的字段
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录(size小于等于0时,忽略翻页查询全部)
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String queryCondition, String orderStr, int startIndex, int size) {
        return queryByCondition(queryCondition, orderStr, startIndex, size, false);
    }
    
    /**
     * 功能: 通过查询条件获得所有的VO对象列表，带翻页，带排序字符，根据selectAllClumn判断是否查询所有字段
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录(size小于等于0时,忽略翻页查询全部)
     * @param selectAllClumn 是否查询所有列，即 SELECT * FROM ...(适用于导出)
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String queryCondition, String orderStr, int startIndex, int size, boolean selectAllClumn) {
        List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> lResult = getDao().queryByCondition(queryCondition, orderStr, startIndex, size, selectAllClumn);
        //RmLogHelper.log(TABLE_LOG_TYPE_NAME, "按条件查询了多条记录,recordCount=" + lResult.size() + ", startIndex=" + startIndex + ", size=" + size + ", queryCondition=" + queryCondition + ", orderStr=" + orderStr + ", selectAllClumn=" + selectAllClumn);
        return lResult;
    }
    <xsl:call-template name="buildMiddleService"/>
}
</xsl:template>
	<!--生成多对多表Service定义-->
	<xsl:template name="buildMiddleService">
		<xsl:variable name="parentChildTable" select="@parentChildTable"/>
			<xsl:analyze-string select="$parentChildTable" regex=",">
				<xsl:non-matching-substring>
					<xsl:analyze-string select="." regex='^\s*([\w_]+)\.([\w_]+)=([\w_]+)\.([\w_]+)\|([\w_]+)=([\w_]+)\.([\w_]+)\(([\w_]+)\.([\w_]+)\)\s*$'>
						<xsl:matching-substring>
    /**
     * 插入中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param <xsl:value-of select="lower-case(regex-group(4))"/>
     * @param <xsl:value-of select="lower-case(regex-group(5))"/>s
     * @return 插入的<xsl:value-of select="lower-case(regex-group(5))"/>列表
     */
    public String[] insert<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(String <xsl:value-of select="lower-case(regex-group(4))"/>, String[] <xsl:value-of select="lower-case(regex-group(5))"/>s) {
    	if(<xsl:value-of select="lower-case(regex-group(5))"/>s.length == 0 || (<xsl:value-of select="lower-case(regex-group(5))"/>s.length == 1 <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> <xsl:value-of select="lower-case(regex-group(5))"/>s[0].trim().length() == 0)) {
    		return new String[0];
    	}
    	IRmCommonService cs = RmProjectHelper.getCommonServiceInstance();
    	List<xsl:value-of select="$charLt"/>String> lExistId = cs.doQuery("SELECT * FROM <xsl:value-of select="regex-group(3)"/> WHERE <xsl:value-of select="regex-group(4)"/>=" + <xsl:value-of select="lower-case(regex-group(4))"/> + " AND <xsl:value-of select="regex-group(5)"/> IN(" + RmStringHelper.parseToString(<xsl:value-of select="lower-case(regex-group(5))"/>s) + ")", new RowMapper() {
			public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
				return rs.getString("<xsl:value-of select="regex-group(5)"/>");
			}
		});
    	Set<xsl:value-of select="$charLt"/>String> s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/> = new HashSet<xsl:value-of select="$charLt"/>String>();
    	for(String <xsl:value-of select="lower-case(regex-group(5))"/> : <xsl:value-of select="lower-case(regex-group(5))"/>s) {
    		if(!lExistId.contains(<xsl:value-of select="lower-case(regex-group(5))"/>)) {
    			s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.add(<xsl:value-of select="lower-case(regex-group(5))"/>);
    		}
    	}
    	if(s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.size() > 0) {
        	String[][] aaValue = new String[s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.size()][2];
        	int index = 0;
        	for (String <xsl:value-of select="lower-case(regex-group(5))"/> : s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>) {
        		aaValue[index][0] = <xsl:value-of select="lower-case(regex-group(4))"/>;
    			aaValue[index][1] = <xsl:value-of select="lower-case(regex-group(5))"/>;
    			index ++;
    		}
        	cs.doUpdateBatch("INSERT INTO <xsl:value-of select="regex-group(3)"/> (<xsl:value-of select="regex-group(4)"/>, <xsl:value-of select="regex-group(5)"/>) VALUES(?, ?)", aaValue);
    	}
        return s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.toArray(new String[0]);
    }
    
    /**
     * 功能: 删除中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param <xsl:value-of select="lower-case(regex-group(4))"/>
     * @param <xsl:value-of select="lower-case(regex-group(5))"/>s
     * @return 删除的记录数
     */
    public int delete<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(String <xsl:value-of select="lower-case(regex-group(4))"/>, String[] <xsl:value-of select="lower-case(regex-group(5))"/>s) {
    	IRmCommonService cs = RmProjectHelper.getCommonServiceInstance();
    	return cs.doUpdate("DELETE FROM <xsl:value-of select="regex-group(3)"/> WHERE <xsl:value-of select="regex-group(4)"/>=" + <xsl:value-of select="lower-case(regex-group(4))"/> + " AND <xsl:value-of select="regex-group(5)"/> IN(" + RmStringHelper.parseToString(<xsl:value-of select="lower-case(regex-group(5))"/>s) + ")");
    }
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
	</xsl:template>
</xsl:stylesheet>
