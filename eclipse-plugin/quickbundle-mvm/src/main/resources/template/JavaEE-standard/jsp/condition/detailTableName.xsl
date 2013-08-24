<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" encoding="UTF-8" escape-uri-attributes="no"/>
	<!--处理table-->
	<xsl:template match="table">
<xsl:value-of select="$charLt"/>%@ page contentType="text/html; charset=UTF-8" language="java" %>
<xsl:if test="column[@isBuild='true' and (@humanDisplayType='rm.dictionary.select' or @humanDisplayType='rm.dictionary.checkbox')]">
<xsl:value-of select="$charLt"/>%@page import="org.quickbundle.project.RmGlobalReference"%>
</xsl:if>
<xsl:value-of select="$charLt"/>%@ page import="org.quickbundle.tools.helper.RmVoHelper" %>
<xsl:value-of select="$charLt"/>%@ page import="org.quickbundle.tools.helper.RmStringHelper" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>" %>
<xsl:if test="contains(@customBundleCode, 'readonly')">
<xsl:value-of select="$charLt"/>%  //判断是否只读
	boolean isReadOnly = false;
	if("1".equals(request.getAttribute(<xsl:value-of select="$ITableNameConstants"/>.REQUEST_IS_READ_ONLY))) {
		isReadOnly = true;
	} 
%>
</xsl:if>
<xsl:value-of select="$charLt"/>%  //取出本条记录
	<xsl:value-of select="$TableNameVo"/> resultVo = null;  //定义一个临时的vo变量
	resultVo = (<xsl:value-of select="$TableNameVo"/>)request.getAttribute(<xsl:value-of select="$ITableNameConstants"/>.REQUEST_BEAN);  //从request中取出vo, 赋值给resultVo
	RmVoHelper.replaceToHtml(resultVo);  //把vo中的每个值过滤
%>
<xsl:value-of select="$charLt"/>!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<xsl:value-of select="$charLt"/>html>
<xsl:value-of select="$charLt"/>head>
<xsl:value-of select="$charLt"/>%@ include file="/jsp/include/rmGlobal.jsp" %>
<xsl:value-of select="$charLt"/>meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<xsl:value-of select="$charLt"/>title><xsl:value-of select="$charLt"/>bean:message key="qb.web_title"/><xsl:value-of select="$charLt"/>/title>
<xsl:value-of select="$charLt"/>script type="text/javascript">
	var rmActionName = "<xsl:value-of select="$tableFormatNameUpperFirst"/>ConditionAction";
	function find_onClick(){  //直接点到修改页面
		form.action="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/" + rmActionName + ".do?cmd=find";
		form.submit();
	}
	function delete_onClick(){  //直接点删除单条记录
		if(!getConfirm()) {  //如果用户在确认对话框中点"取消"
			return false;
		}
		form.action="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/" + rmActionName + ".do?cmd=delete";
		form.submit();
	}  
<xsl:value-of select="$charLt"/>/script>
<xsl:value-of select="$charLt"/>/head>
<xsl:value-of select="$charLt"/>body>
<xsl:value-of select="$charLt"/>form name="form" method="post">
<xsl:value-of select="$charLt"/>br/>
<xsl:value-of select="$charLt"/>table class="mainTable">
	<xsl:value-of select="$charLt"/>tr>
		<xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
		<xsl:value-of select="$charLt"/>td width="35%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
		<xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
		<xsl:value-of select="$charLt"/>td width="25%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
	<xsl:value-of select="$charLt"/>/tr>
	<xsl:apply-templates mode="buildTableColumn_detailDisplay"/>
<xsl:value-of select="$charLt"/>/table>

<xsl:value-of select="$charLt"/>input type="hidden" name="id" value="<xsl:value-of select="$charLt"/>%=RmStringHelper.prt(resultVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>())%>">
<xsl:if test="not($statisticColumnFormatLower='id')"><xsl:value-of select="$charLt"/>input type="hidden" name="<xsl:value-of select="$statisticColumnFormatLower"/>" value="<xsl:value-of select="$charLt"/>%=RmStringHelper.prt(resultVo.get<xsl:value-of select="str:upperFirst($statisticColumnFormatLower)"/>())%>"></xsl:if> 

<xsl:value-of select="$charLt"/>table align="center">
	<xsl:value-of select="$charLt"/>tr>
		<xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>br>
			<xsl:if test="contains(@customBundleCode, 'readonly')"><xsl:value-of select="$charLt"/>%if(!isReadOnly) { %></xsl:if>
			<xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_update" value="修改" onclick="javascript:find_onClick();">
			<xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_delete" value="删除" onclickto="javascript:delete_onClick();">
			<xsl:if test="contains(@customBundleCode, 'readonly')"><xsl:value-of select="$charLt"/>%}%></xsl:if>
			<xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_back" value="返回"  onclick="javascript:history.go(-1);" >
		<xsl:value-of select="$charLt"/>/td>
	<xsl:value-of select="$charLt"/>/tr>
<xsl:value-of select="$charLt"/>/table>

<xsl:value-of select="$charLt"/>%-- 开始子表信息，带页签集成多个子表 --%>
<xsl:value-of select="$charLt"/>script type="text/javascript">
var childTableTabs  =  new Array(
<xsl:call-template name="buildChildTable"/>
	null
);
<xsl:value-of select="$charLt"/>/script>
<xsl:value-of select="$charLt"/>table class="table_div_content">
	<xsl:value-of select="$charLt"/>tr>
		<xsl:value-of select="$charLt"/>td>
			<xsl:value-of select="$charLt"/>div id="childTableTabsDiv"><xsl:value-of select="$charLt"/>/div>
		<xsl:value-of select="$charLt"/>/td>
	<xsl:value-of select="$charLt"/>/tr>
<xsl:value-of select="$charLt"/>/table>
<xsl:value-of select="$charLt"/>%-- 结束子表信息 --%>

<xsl:value-of select="$charLt"/>/form>
<xsl:value-of select="$charLt"/>/body>
<xsl:value-of select="$charLt"/>/html>
	</xsl:template>
</xsl:stylesheet>