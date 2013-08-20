<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
	<xsl:if test="contains(@customBundleCode, 'main')">
	<xsl:value-of select="$charLt"/>!--<xsl:value-of select="$tableFormatNameUpperFirst"/> <xsl:value-of select="$tableFormatNameUpperFirst"/>的struts跳转规则-->
	<xsl:value-of select="$charLt"/>action type="<xsl:value-of select="$TableNameActionFullPath"/>" scope="request" path="/<xsl:value-of select="$TableNameAction"/>" parameter="cmd">
		<xsl:value-of select="$charLt"/>forward name="toQueryAll" path="/<xsl:value-of select="$TableNameAction"/>.do?cmd=queryAll" redirect="true"/>
		<xsl:value-of select="$charLt"/>forward name="listPage" path="/<xsl:value-of select="$jspFullPath"/>/<xsl:value-of select="$listTableNameJsp"/>"/>
		<xsl:value-of select="$charLt"/>forward name="updatePage" path="/<xsl:value-of select="$jspFullPath"/>/<xsl:value-of select="$insertTableNameJsp"/>?isModify=1"/>
		<xsl:value-of select="$charLt"/>forward name="detailPage" path="/<xsl:value-of select="$jspFullPath"/>/<xsl:value-of select="$detailTableNameJsp"/>"/>
		<xsl:if test="contains(@customBundleCode, 'reference')">
		<xsl:value-of select="$charLt"/>forward name="referencePage" path="/<xsl:value-of select="$jspUtilFullPath"/>/<xsl:value-of select="$referenceTableNameJsp"/>"/>
		</xsl:if>
		<xsl:if test="contains(@customBundleCode, 'statistic')">
		<xsl:value-of select="$charLt"/>forward name="statisticPage" path="/<xsl:value-of select="$jspUtilFullPath"/>/<xsl:value-of select="$statisticTableName_rowColumnJsp"/>"/>
		</xsl:if>
	<xsl:value-of select="$charLt"/>/action>
	</xsl:if>
	<xsl:if test="contains(@customBundleCode, 'readonly')">
	<xsl:value-of select="$charLt"/>!--<xsl:value-of select="$tableFormatNameUpperFirst"/> <xsl:value-of select="$tableFormatNameUpperFirst"/>ReadOnly的struts跳转规则-->
    <xsl:value-of select="$charLt"/>action type="<xsl:value-of select="$TableNameReadOnlyActionFullPath"/>" scope="request" path="/<xsl:value-of select="$TableNameReadOnlyAction"/>" parameter="cmd">
		<xsl:value-of select="$charLt"/>forward name="toQueryAll" path="/<xsl:value-of select="$TableNameReadOnlyAction"/>.do?cmd=queryAll" redirect="true"/>
		<xsl:value-of select="$charLt"/>forward name="listPage" path="/<xsl:value-of select="$jspFullPath"/>/<xsl:value-of select="$listTableNameJsp"/>?request_is_read_only=1"/>
		<xsl:value-of select="$charLt"/>forward name="detailPage" path="/<xsl:value-of select="$jspFullPath"/>/<xsl:value-of select="$detailTableNameJsp"/>?request_is_read_only=1"/>
	<xsl:value-of select="$charLt"/>/action>
	</xsl:if>
	<xsl:if test="contains(@customBundleCode, 'condition')">
	<xsl:value-of select="$charLt"/>!--<xsl:value-of select="$tableFormatNameUpperFirst"/> <xsl:value-of select="$tableFormatNameUpperFirst"/>Condition的struts跳转规则-->
    <xsl:value-of select="$charLt"/>action type="<xsl:value-of select="$TableNameConditionActionFullPath"/>" scope="request" path="/<xsl:value-of select="$TableNameConditionAction"/>" parameter="cmd">
		<xsl:value-of select="$charLt"/>forward name="toQueryAll" path="/<xsl:value-of select="$TableNameConditionAction"/>.do?cmd=queryAll" redirect="true"/>
		<xsl:value-of select="$charLt"/>forward name="listPage" path="/<xsl:value-of select="$jspConditionFullPath"/>/<xsl:value-of select="$listTableNameJsp"/>"/>
		<xsl:value-of select="$charLt"/>forward name="updatePage" path="/<xsl:value-of select="$jspConditionFullPath"/>/<xsl:value-of select="$insertTableNameJsp"/>?isModify=1"/>
		<xsl:value-of select="$charLt"/>forward name="detailPage" path="/<xsl:value-of select="$jspConditionFullPath"/>/<xsl:value-of select="$detailTableNameJsp"/>"/>
	<xsl:value-of select="$charLt"/>/action>
	</xsl:if>
	<xsl:if test="contains(@customBundleCode, 'ajax')">
	<xsl:value-of select="$charLt"/>!--<xsl:value-of select="$tableFormatNameUpperFirst"/> <xsl:value-of select="$tableFormatNameUpperFirst"/>Ajax的struts跳转规则-->
    <xsl:value-of select="$charLt"/>action type="<xsl:value-of select="$TableNameAjaxActionFullPath"/>" scope="request" path="/<xsl:value-of select="$TableNameAjaxAction"/>" parameter="cmd" />
	</xsl:if>
	</xsl:template>
</xsl:stylesheet>
