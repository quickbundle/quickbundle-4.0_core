<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table[1]">
		<xsl:value-of select="str:getJavaFileComment($authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>;

import java.util.Map;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.quickbundle.project.IGlobalConstants;

<xsl:value-of select="str:getClassComment($authorName)"/>

public interface <xsl:value-of select="$ITableNameConstants"/> extends IGlobalConstants {

    //表名、显示名
    public final static String TABLE_NAME = "<xsl:value-of select="@tableName"/>";
    public final static String TABLE_NAME_DISPLAY = "<xsl:value-of select="@tableNameDisplay"/>";
    //列名汉化
    @SuppressWarnings({ "unchecked", "serial" })
    public final static Map<xsl:value-of select="$charLt"/>String, String> TABLE_COLUMN_DISPLAY = new CaseInsensitiveMap(){{
        
        put("id","主键");
        put("biz_keyword","业务关键字");
        put("sender_id","发送人ID");
        put("parent_message_id","父消息ID");
        put("owner_org_id","所属组织ID");
        put("template_id","模板ID");
        put("is_affix","有无附件");
        put("record_id","主记录ID");
        put("message_xml_context","消息XML内容");
        put("usable_status","数据可用状态");
        put("modify_date","修改日期");
        put("modify_ip","修改IP");
        put("modify_user_id","修改用户ID");
    }};


    //子表1-消息收件人-表名、显示名
    public final static String TABLE_NAME_<xsl:value-of select="@tableName"/> = "<xsl:value-of select="@tableName"/>";
    public final static String TABLE_NAME_DISPLAY_<xsl:value-of select="@tableName"/> = "消息收件人";
    public final static String TABLE_PK_<xsl:value-of select="@tableName"/> = "<xsl:value-of select="$tablePk"/>";
    //子表1-列名汉化
    @SuppressWarnings({"unchecked", "serial" })
    public final static Map<xsl:value-of select="$charLt"/>String, String> TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/> = new CaseInsensitiveMap(){{
        
        put("id","主键");
        put("message_id","消息ID");
        put("receiver_id","接收人ID");
        put("is_handle","是否办理");
        put("handle_date","办理时间");
        put("handle_result","办理结果");
        put("usable_status","数据可用状态");
        put("modify_date","修改日期");
        put("modify_ip","修改IP");
        put("modify_user_id","修改用户ID");
    }};
    
    //日志类型名称
    public final static String LOG_TYPE_NAME = TABLE_NAME_DISPLAY + "管理";
}
</xsl:template>

	<!--处理TABLE_COLUMN_DISPLAY的循环部分-->
	<xsl:template match="column" mode="table_column_display_put">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		put("<xsl:value-of select="$columnNameFormatLower"/>","<xsl:value-of select="@columnNameDisplay"/>");</xsl:template>
</xsl:stylesheet>
