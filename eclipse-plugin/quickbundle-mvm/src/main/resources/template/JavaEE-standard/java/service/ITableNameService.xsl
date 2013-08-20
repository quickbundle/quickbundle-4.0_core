<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:param name="thisFilePathName">
			<xsl:value-of select="$ITableNameServicePackage"/> --> <xsl:value-of select="$ITableNameService"/>.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$ITableNameServicePackage"/>;

import java.util.List;

import <xsl:value-of select="$ITableNameDaoFullPath"/>;
import <xsl:value-of select="$TableNameVoFullPath"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>
public interface <xsl:value-of select="$ITableNameService"/> {

    /**
     * 设置数据访问接口
     * 
     * @return
     */
    public <xsl:value-of select="$ITableNameDao"/> getDao();

    /**
     * 获取数据访问接口
     * 
     * @param dao
     */
    public void setDao(<xsl:value-of select="$ITableNameDao"/> dao);

    /**
     * 插入单条记录
     * 
     * @param vo 用于添加的VO对象
     * @return 若添加成功，返回新生成的id
     */
    public String insert(<xsl:value-of select="$TableNameVo"/> vo);
    
    /**
     * 插入多条记录
     *
     * @param vos 用于添加的VO对象数组
     * @return 返回新生成的id数组
     */
    public String[] insert(<xsl:value-of select="$TableNameVo"/>[] vos);

    /**
     * 删除单条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(String id);

    /**
     * 删除多条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(String id[]);

    /**
     * 根据Id进行查询
     * 
     * @param id 用于查找的id
     * @return 查询到的VO对象
     */
    public <xsl:value-of select="$TableNameVo"/> find(String id);

    /**
     * 更新单条记录
     * 
     * @param vo 用于更新的VO对象
     * @return 成功更新的记录数
     */
    public int update(<xsl:value-of select="$TableNameVo"/> vo);

    /**
     * 批量更新修改多条记录
     * 
     * @param vos 更新的VO对象数组
     * @return 成功更新的记录最终数量
     */
	public int update(<xsl:value-of select="$TableNameVo"/>[] vos);
	
	/**
	 * 批量保存，没有主键的insert，有主键的update
	 * 
	 * @param vos 更新的VO对象数组
	 * @return new int[2]{insert的记录数, update的记录数}	
	 */
	public int[] insertUpdateBatch(<xsl:value-of select="$TableNameVo"/>[] vos);

    /**
     * 查询总记录数，带查询条件
     * 
     * @param queryCondition 查询条件
     * @return 总记录数
     */
    public int getRecordCount(String queryCondition);
    
    /**
     * 功能: 通过查询条件获得所有的VO对象列表，不带翻页查全部
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字段
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String queryCondition, String orderStr);
    
    /**
     * 功能: 通过查询条件获得所有的VO对象列表，带翻页，带排序字符
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录(size小于等于0时,忽略翻页查询全部)
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String queryCondition, String orderStr, int startIndex, int size);

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
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> queryByCondition(String queryCondition, String orderStr, int startIndex, int size, boolean selectAllClumn);
    <xsl:call-template name="buildMiddleIService"/>
}
</xsl:template>
	<!--生成多对多表IService接口定义-->
	<xsl:template name="buildMiddleIService">
		<xsl:variable name="parentChildTable" select="@parentChildTable"/>
			<xsl:analyze-string select="$parentChildTable" regex=",">
				<xsl:non-matching-substring>
					<xsl:analyze-string select="." regex='^\s*([\w_]+)\.([\w_]+)=([\w_]+)\.([\w_]+)\|([\w_]+)=([\w_]+)\.([\w_]+)\(([\w_]+)\.([\w_]+)\)\s*$'>
						<xsl:matching-substring>
    /**
     * 功能: 插入中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param <xsl:value-of select="lower-case(regex-group(4))"/>
     * @param <xsl:value-of select="lower-case(regex-group(5))"/>s
     * @return 成功插入的<xsl:value-of select="lower-case(regex-group(5))"/>数组
     */
    public String[] insert<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(String <xsl:value-of select="lower-case(regex-group(4))"/>, String[] <xsl:value-of select="lower-case(regex-group(5))"/>s);
    
    /**
     * 功能: 删除中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param <xsl:value-of select="lower-case(regex-group(4))"/>
     * @param <xsl:value-of select="lower-case(regex-group(5))"/>s
     * @return 删除的记录数
     */
    public int delete<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(String <xsl:value-of select="lower-case(regex-group(4))"/>, String[] <xsl:value-of select="lower-case(regex-group(5))"/>s);
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
	</xsl:template>
</xsl:stylesheet>
