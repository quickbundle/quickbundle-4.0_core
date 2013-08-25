<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:value-of select="str:getJavaFileComment($authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>;

import java.util.Map;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.quickbundle.project.IGlobalConstants;

<xsl:value-of select="str:getClassComment($authorName)"/>

public interface <xsl:value-of select="$ITableNameConstants"/> extends IGlobalConstants {

    //Service的规范化名称
    public final static String SERVICE_KEY = "I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service";

    //Sql语句
    public final static String AFTER_SELECT_ALL   = "<xsl:value-of select="$tableName"/>.<xsl:value-of select="$tablePk"/>, <xsl:apply-templates mode="queryAll_1"/>";
    public final static String AFTER_SELECT_SHORT = "<xsl:value-of select="$tableName"/>.<xsl:value-of select="$tablePk"/>, <xsl:apply-templates mode="queryAll_list"/>";

    public final static String SQL_INSERT = "insert into <xsl:value-of select="$tableName"/> ( <xsl:value-of select="$tablePk"/>, <xsl:apply-templates mode="insert_1"/>) values ( ?, <xsl:apply-templates mode="insert_2"/> )";
    
    public final static String SQL_DELETE_BY_ID = "delete from <xsl:value-of select="$tableName"/> where <xsl:value-of select="$tablePk"/>=?";
    
    public final static String SQL_DELETE_MULTI_BY_IDS = "delete from <xsl:value-of select="$tableName"/> ";

    public final static String SQL_FIND_BY_ID = "select " + AFTER_SELECT_ALL + " from <xsl:value-of select="$tableName"/> where <xsl:value-of select="$tableName"/>.<xsl:value-of select="$tablePk"/>=?";

    public final static String SQL_UPDATE_BY_ID = "update <xsl:value-of select="$tableName"/> set <xsl:apply-templates mode="update_1"/>  where <xsl:value-of select="$tablePk"/>=?";
    
    public final static String SQL_COUNT = "select count(<xsl:value-of select="$tableName"/>.<xsl:value-of select="$tablePk"/>) from <xsl:value-of select="$tableName"/>";
    
    public final static String SQL_QUERY_ALL = "select " + AFTER_SELECT_SHORT + " from <xsl:value-of select="$tableName"/>";

	public final static String SQL_QUERY_ALL_EXPORT = "select " + AFTER_SELECT_ALL + " from <xsl:value-of select="$tableName"/>";
    
    //表名
    public final static String TABLE_NAME = "<xsl:value-of select="$tableName"/>";
    
    //表名汉化
    public final static String TABLE_NAME_DISPLAY = "<xsl:value-of select="$tableNameDisplay"/>";
    
    //列名汉化
    @SuppressWarnings("unchecked")
    public final static Map<xsl:value-of select="$charLt"/>String, String> TABLE_COLUMN_DISPLAY = new CaseInsensitiveMap(){{
		<xsl:apply-templates mode="table_column_display_put"/>
    }};
    
    //日志类型名称
    public final static String TABLE_LOG_TYPE_NAME = TABLE_NAME_DISPLAY + "管理";
    
    //默认启用的查询条件
    public final static String DEFAULT_SQL_WHERE_USABLE = ""; //" where " + DESC_USABLE_STATUS_EVALUATE_ENABLE
    
    public final static String DEFAULT_SQL_CONTACT_KEYWORD = " where ";
    
    //默认的排序字段
    public final static String DEFAULT_ORDER_BY_CODE = ""; //ORDER_BY_SYMBOL + DESC_ORDER_CODE
    
    //子表查询条件，[0]作为默认条件查询字段
    public final static String[] DEFAULT_CONDITION_KEY_ARRAY = new String[]{"<xsl:value-of select="$statisticColumnFormatLower"/>", "<xsl:value-of select="$statisticColumnFormatLower"/>_name"}; <!--xsl:if test="column[@columnName=concat($statisticColumn, '_name')] or column[@columnName=concat($statisticColumn, '_NAME')]"-->
}
</xsl:template>
	<!--处理insert语句的前半部分-->
	<xsl:template match="column" mode="insert_1">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))">
					<xsl:value-of select="$columnName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$columnName"/>, </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--处理insert语句的后半部分-->
	<xsl:template match="column" mode="insert_2">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="@dataType='java.lang.String'">?</xsl:when>
				<!--标准的jdbc一律为?-->
				<xsl:otherwise>?</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--处理queryAll语句的循环部分-->
	<xsl:template match="column" mode="queryAll_1">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="@dataType='java.lang.String'">
					<xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--处理queryAll_list语句的循环部分-->
	<xsl:template match="column" mode="queryAll_list">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk) and @isBuild_list='true'">
			<xsl:choose>
				<xsl:when test="@dataType='java.lang.String'">
					<xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:when test="@columnName=(../column[@isBuild_list='true'][position()=last()]/@columnName)"/>
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--处理update语句的循环部分-->
	<xsl:template match="column" mode="update_1">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>
				<xsl:when test="@dataType='java.lang.String'">
					<xsl:value-of select="concat($columnName,'=?')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($columnName,'=?')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>				
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--处理TABLE_COLUMN_DISPLAY的循环部分-->
	<xsl:template match="column" mode="table_column_display_put">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		put("<xsl:value-of select="$columnNameFormatLower"/>","<xsl:value-of select="@columnNameDisplay"/>");</xsl:template>
</xsl:stylesheet>
