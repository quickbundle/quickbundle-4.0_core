<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:param name="thisFilePathName">
			<xsl:value-of select="$javaPackageTableDir"/>.dao.impl --> <xsl:value-of select="$tableFormatNameUpperFirst"/>Dao.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.quickbundle.base.beans.factory.RmIdFactory;
import org.quickbundle.base.dao.RmJdbcTemplate;
import org.quickbundle.tools.helper.RmPopulateHelper;
import org.quickbundle.tools.helper.RmStringHelper;
import org.springframework.jdbc.core.RowMapper;

import <xsl:value-of select="$javaPackageTableDir"/>.dao.I<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao;
import <xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>
public class <xsl:value-of select="$tableFormatNameUpperFirst"/>Dao extends RmJdbcTemplate implements I<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao, <xsl:value-of select="$ITableNameConstants"/> {

    /**
     * 插入单条记录，从RmIdFactory取id作主键
     * 
     * @param vo 用于添加的VO对象
     * @return 若添加成功，返回新生成的Oid
     */
    public String insert(<xsl:value-of select="$TableNameVo"/> vo) {
    	if(vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() == null || vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>().length() == 0) {
    		vo.set<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(RmIdFactory.requestId(TABLE_NAME)); //获得id
    	}
        Object[] obj = { vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(), <xsl:apply-templates select="column" mode="buildGetCircle"/> };
        update(SQL_INSERT, obj);
        return vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>();
    }

    /**
     * 批量更新插入多条记录，用id作主键
     * 
     * @param vos 添加的VO对象数组
     * @return 若添加成功，返回新生成的id数组
     */
	public String[] insert(final <xsl:value-of select="$TableNameVo"/>[] vos) {
		String[] ids = RmIdFactory.requestId(TABLE_NAME, vos.length); //获得id
		for(int i=0; i<xsl:value-of select="$charLt"/>vos.length; i++) {
			vos[i].set<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(ids[i]);
		}
		batchUpdate(SQL_INSERT, vos, new RmJdbcTemplate.CircleVoArray() {
			public Object[] getArgs(Object obj) {
				<xsl:value-of select="$TableNameVo"/> vo = (<xsl:value-of select="$TableNameVo"/>)obj;
				return new Object[]{ vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(), <xsl:apply-templates select="column" mode="buildGetCircle"/> };
			}
		});
		return ids;
	}
	
    /**
     * 删除单条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(String id) {
        return update(SQL_DELETE_BY_ID, new Object[] { id });
    }

    /**
     * 删除多条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(String id[]) {
        if (id == null || id.length == 0)
            return 0;
        StringBuilder sql = new StringBuilder(SQL_DELETE_MULTI_BY_IDS);
        sql.append(" WHERE <xsl:value-of select="$tablePk"/> IN (");
        sql.append(RmStringHelper.parseToSQLStringApos(id)); //把id数组转换为id1,id2,id3
        sql.append(")");
        return update(sql.toString());
    }

    /**
     * 根据id进行查询
     * 
     * @param id 用于查找的id
     * @return 查询到的VO对象
     */
    public <xsl:value-of select="$TableNameVo"/> find(String id) {
        return (<xsl:value-of select="$TableNameVo"/>) queryForObject(SQL_FIND_BY_ID, new Object[] { id }, new RowMapper() {
            public Object mapRow(ResultSet rs, int i) throws SQLException {
                <xsl:value-of select="$TableNameVo"/> vo = new <xsl:value-of select="$TableNameVo"/>();
                RmPopulateHelper.populate(vo, rs);
                return vo;
            }
        });
    }

    /**
     * 更新单条记录
     * 
     * @param vo 用于更新的VO对象
     * @return 成功更新的记录数
     */
    public int update(<xsl:value-of select="$TableNameVo"/> vo) {
        Object[] obj = { <xsl:apply-templates select="column" mode="buildGetCircle_update"/>, vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() };
        return update(SQL_UPDATE_BY_ID, obj);
    }

    /**
     * 批量更新修改多条记录
     * 
     * @param vos 添加的VO对象数组
     * @return 成功更新的记录数组
     */
	public int[] update(final <xsl:value-of select="$TableNameVo"/>[] vos) {
		return batchUpdate(SQL_UPDATE_BY_ID, vos, new RmJdbcTemplate.CircleVoArray() {
			public Object[] getArgs(Object obj) {
				<xsl:value-of select="$TableNameVo"/> vo = (<xsl:value-of select="$TableNameVo"/>)obj;
				return new Object[]{ <xsl:apply-templates select="column" mode="buildGetCircle_update"/>, vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() };
			}
		});
	}

    /**
     * 查询总记录数，带查询条件
     * 
     * @param queryCondition 查询条件
     * @return 总记录数
     */
    public int getRecordCount(String queryCondition) {
    	StringBuilder sql = new StringBuilder(SQL_COUNT + DEFAULT_SQL_WHERE_USABLE);
        if (queryCondition != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> queryCondition.trim().length() > 0) {
        	sql.append(DEFAULT_SQL_CONTACT_KEYWORD); //where后加上查询条件
        	sql.append(queryCondition);
        }
        return queryForInt(sql.toString());
    }

    /**
     * 功能: 通过查询条件获得所有的VO对象列表，带翻页，带排序字符
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录(size小于等于0时,忽略翻页查询全部)
     * @param selectAllClumn 是否查询所有列，即 SELECT * FROM ...(适用于导出)
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String queryCondition, String orderStr, int startIndex, int size, boolean selectAllClumn) {
    	StringBuilder sql = new StringBuilder();
        if(selectAllClumn) {
        	sql.append(SQL_QUERY_ALL_EXPORT + DEFAULT_SQL_WHERE_USABLE);
        } else {
        	sql.append(SQL_QUERY_ALL + DEFAULT_SQL_WHERE_USABLE);
        }
        if (queryCondition != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> queryCondition.trim().length() > 0) {
        	sql.append(DEFAULT_SQL_CONTACT_KEYWORD); //where后加上查询条件
        	sql.append(queryCondition);
        }
        if(orderStr != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> orderStr.trim().length() > 0) {
        	sql.append(ORDER_BY_SYMBOL);
        	sql.append(orderStr);
        } else {
        	sql.append(DEFAULT_ORDER_BY_CODE);
        }
        return queryByCondition(sql.toString(), startIndex, size);
    }
    
    /**
     * 通过传入的sql，查询所有的VO对象列表
     * 
     * @param sql 完整的查询sql语句
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size  查询多少条记录(size小于等于0时,忽略翻页查询全部)
     * @return 查询到的VO列表
     */
    @SuppressWarnings("unchecked")
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String sql, int startIndex, int size) {
        if(size <xsl:value-of select="$charLt"/>= 0) {
            return query(sql.toString(), new RowMapper() {
                public Object mapRow(ResultSet rs, int i) throws SQLException {
                    <xsl:value-of select="$TableNameVo"/> vo = new <xsl:value-of select="$TableNameVo"/>();
                    RmPopulateHelper.populate(vo, rs);
                    return vo;
                }
            });
        } else {
            return query(sql.toString(), new RowMapper() {
                public Object mapRow(ResultSet rs, int i) throws SQLException {
                    <xsl:value-of select="$TableNameVo"/> vo = new <xsl:value-of select="$TableNameVo"/>();
                    RmPopulateHelper.populate(vo, rs);
                    return vo;
                }
            }, startIndex, size); 
        }
    }
}
	</xsl:template>
	<!--处理取vo各属性的循环部分-->
	<xsl:template match="column" mode="buildGetCircle">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="@dataType='not_exist_java_data_type'"/>
				<xsl:otherwise>
					<xsl:value-of select="concat('vo.get', str:upperFirst($columnNameFormatLower),'()')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:otherwise>,<xsl:value-of select="$charBr"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--处理取vo各属性的循环部分 update-->
	<xsl:template match="column" mode="buildGetCircle_update">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="@dataType='not_exist_java_data_type'"/>
				<xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>
				<xsl:otherwise>
					<xsl:value-of select="concat('vo.get', str:upperFirst($columnNameFormatLower),'()')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>
				<xsl:otherwise>,<xsl:value-of select="$charBr"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>